# encoding: utf-8
begin
  require 'fog'
rescue LoadError
  raise "You don't have the 'fog' gem installed. The 'aws', 'aws-s3' and 'right_aws' gems are no longer supported."
end

module CarrierWave
  module Storage

    class S3 < Abstract

      class File

        def initialize(uploader, base, path)
          @uploader = uploader
          @path = path
          @base = base
        end

        ##
        # Returns the current path of the file on S3
        #
        # === Returns
        #
        # [String] A path
        #
        def path
          @path
        end

        ##
        # Reads the contents of the file from S3
        #
        # === Returns
        #
        # [String] contents of the file
        #
        def read
          result = connection.get_object(bucket, @path)
          @headers = result.headers
          result.body
        end

        ##
        # Remove the file from Amazon S3
        #
        def delete
          connection.delete_object(bucket, @path)
        end

        ##
        # Returns the url on Amazon's S3 service
        #
        # === Returns
        #
        # [String] file's url
        #
        def url
          if access_policy == :authenticated_read
            authenticated_url
          else
            public_url
          end
        end

        def public_url
          scheme = use_ssl? ? 'https' : 'http'
          if cnamed?
            ["#{scheme}://#{bucket}", path].compact.join('/')
          else
            ["#{scheme}://#{bucket}.s3.amazonaws.com", path].compact.join('/')
          end
        end

        def authenticated_url
          connection.get_object_url(bucket, path, Time.now + authentication_timeout)
        end

        def store(file)
          content_type ||= file.content_type # this might cause problems if content type changes between read and upload (unlikely)
          connection.put_object(bucket, path, file.read,
            {
              'x-amz-acl' => access_policy.to_s.gsub('_', '-'),
              'Content-Type' => content_type
            }.merge(@uploader.s3_headers)
          )
        end

        def content_type
          headers["Content-Type"]
        end

        def content_type=(type)
          headers["Content-Type"] = type
        end

        def size
           headers['Content-Length'].to_i
        end

        # Headers returned from file retrieval
        def headers
          @headers ||= begin
            connection.head_object(bucket, @path).headers
          rescue Excon::Errors::NotFound # Don't die, just return no headers
            {}
          end
        end

      private

        def use_ssl?
          @uploader.s3_use_ssl
        end

        def cnamed?
          @uploader.s3_cnamed
        end

        def access_policy
          @uploader.s3_access_policy
        end

        def bucket
          @uploader.s3_bucket
        end

        def authentication_timeout
          @uploader.s3_authentication_timeout
        end

        def connection
          @base.connection
        end

      end

      ##
      # Store the file on S3
      #
      # === Parameters
      #
      # [file (CarrierWave::SanitizedFile)] the file to store
      #
      # === Returns
      #
      # [CarrierWave::Storage::S3::File] the stored file
      #
      def store!(file)
        f = CarrierWave::Storage::S3::File.new(uploader, self, uploader.store_path)
        f.store(file)
        f
      end

      # Do something to retrieve the file
      #
      # @param [String] identifier uniquely identifies the file
      #
      # [identifier (String)] uniquely identifies the file
      #
      # === Returns
      #
      # [CarrierWave::Storage::S3::File] the stored file
      #
      def retrieve!(identifier)
        CarrierWave::Storage::S3::File.new(uploader, self, uploader.store_path(identifier))
      end

      def connection
        @connection ||= ::Fog::Storage.new(
          :aws_access_key_id      => 'AKIAILKXQWKJZPLUS6MA',
          :aws_secret_access_key  => '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',
          :provider               => 'AWS',
          :region                 => 'us-east-1'
        )
      end

    end # S3
  end # Storage
end # CarrierWave