module SapphireBot
  STATS = Stats.new
  GOOGLE = GoogleServices.new

  bot = Discordrb::Commands::CommandBot.new(token: CONFIG[:discord_token],
                                            application_id: CONFIG[:discord_client_id],
                                            prefix: CONFIG[:prefix],
                                            advanced_functionality: false)

  bot.bucket(:voice, delay: 300)

  bot.include! Commands::Announce
  bot.include! Commands::Delete
  bot.include! Commands::Flip
  bot.include! Commands::Invite
  bot.include! Commands::Lmgtfy
  bot.include! Commands::Roll
  bot.include! Commands::Stats
  bot.include! Commands::Ping
  bot.include! Commands::KickAll
  bot.include! Commands::Leave
  bot.include! Commands::About
  bot.include! Commands::Avatar
  bot.include! Commands::Eval
  bot.include! Commands::Toggle
  bot.include! Commands::Set
  bot.include! Commands::Default
  bot.include! Commands::Settings
  bot.include! Commands::Game
  bot.include! Commands::Ignore
  bot.include! Commands::YoutubeSearch
  bot.include! Commands::Roasted
  bot.include! Events::Mention
  bot.include! Events::MessagesReadStat
  bot.include! Events::AutoShorten
  bot.include! Events::MassMessage
  bot.include! Events::ReadyMessage

  system("clear")

  Thread.new do
    loop do
      STATS.update(bot)
      STATS.save
      ServerConfig.save
      STATS.inspect
      sleep(60)
    end
  end

  Thread.new do
    LOGGER.info 'Type exit to safely stop the bot'
    loop do
      next unless gets.chomp == 'exit'
      LOGGER.info 'Exiting...'
      STATS.save
      ServerConfig.save
      exit
    end
  end

  LOGGER.info "Oauth url: #{bot.invite_url}+&permissions=#{CONFIG[:permissions_code]}"
  bot.run
end
