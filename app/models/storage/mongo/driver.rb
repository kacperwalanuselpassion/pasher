module Storage::Mongo
  module Driver
    class << self
      def db
        driver.db(database_name)
      end

      protected
      def database_name
        ENV['MONGOHQ_URL'].split('/')[-1]
      end

      def driver
        Mongo::MongoClient.from_uri ENV['MONGOHQ_URL']
      end
    end
  end
end
