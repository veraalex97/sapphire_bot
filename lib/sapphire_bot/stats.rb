module SapphireBot
  # Stores bot statistics.
  class Stats
    include StoreData

    attr_reader :servers, :users, :uptime

    def initialize
      @file = "#{Dir.pwd}/data/stats.yml"

      temp = load_file(@file)
      if temp.is_a?(Hash) && !temp.empty?
        @stats = temp
      else
        @stats = {}
        @stats[:urls_shortened] = 0
        @stats[:messages_read] = 0
        @stats[:urls_shortened] = 0
        @stats[:videos_found] = 0
        @stats[:mentions] = 0
        @stats[:songs_played] = 0
      end

      @uptime = 0
      @servers = 0
      @users = 0
      @start_time = Time.now.to_i

      create_methods
      start_loop
    end

    def update
      @servers = BOT.servers.size
      @users = BOT.users.size
      @uptime = (Time.now - @start_time).to_i
    end

    def save
      LOGGER.debug 'Saving stats'
      save_to_file(@file, @stats)
    end

    def inspect
      LOGGER.info "Users: #{@users}"
      LOGGER.info "Servers: #{@servers}"
      LOGGER.info "Uptime: #{@uptime}"
      @stats.each { |key, value| LOGGER.info "#{key.to_s.tr('_', ' ').capitalize}: #{value} " }
    end

    private

    # Creates get and set methods from hash keys.
    def create_methods
      @stats.keys.each do |key|
        self.class.send(:define_method, key) do
          @stats[key]
        end

        self.class.send(:define_method, "#{key}=") do |value|
          @stats[key] = value
        end
      end
    end

    # Starts a loop that updates and saves stats every 60 seconds.
    def start_loop
      Thread.new do
        loop do
          update
          save
          sleep(60)
        end
      end
    end
  end
end
