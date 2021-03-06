# Base module for sapphire
module SapphireBot
  BOT = Discordrb::Commands::CommandBot.new(token: CONFIG.discord_token,
                                            application_id: CONFIG.discord_client_id,
                                            prefix: CONFIG.prefix,
                                            advanced_functionality: false)
  GOOGLE = GoogleServices.new
  STATS = Stats.new

  BOT.include! Commands::Announce
  BOT.include! Commands::Delete
  BOT.include! Commands::Flip
  BOT.include! Commands::Invite
  BOT.include! Commands::Lmgtfy
  BOT.include! Commands::Roll
  BOT.include! Commands::Stats
  BOT.include! Commands::Ping
  BOT.include! Commands::KickAll
  BOT.include! Commands::About
  BOT.include! Commands::Avatar
  BOT.include! Commands::Eval
  BOT.include! Commands::Toggle
  BOT.include! Commands::Set
  BOT.include! Commands::Default
  BOT.include! Commands::Settings
  BOT.include! Commands::Game
  BOT.include! Commands::Ignore
  BOT.include! Commands::YoutubeSearch
  BOT.include! Commands::MusicHelp
  BOT.include! Commands::Join
  BOT.include! Commands::Leave
  BOT.include! Commands::Add
  BOT.include! Commands::Queue
  BOT.include! Commands::ClearQueue
  BOT.include! Commands::Skip
  BOT.include! Commands::Repeat

  BOT.include! Events::Mention
  BOT.include! Events::MessagesReadStat
  BOT.include! Events::AutoShorten
  BOT.include! Events::MassMessage
  BOT.include! Events::ReadyMessage

  # A loop that checks for user input.
  Thread.new do
    LOGGER.info 'Type "exit" to safely stop the bot or "inspect" to see bot statistics'
    loop do
      input = gets.chomp
      STATS.inspect if input == 'inspect'
      next unless input == 'exit'
      LOGGER.info 'Exiting...'
      STATS.save
      ServerConfig.save
      MusicBot.delete_files
      exit
    end
  end

  LOGGER.info "Oauth url: #{BOT.invite_url}+&permissions=#{CONFIG.permissions_code}"
  BOT.run
end
