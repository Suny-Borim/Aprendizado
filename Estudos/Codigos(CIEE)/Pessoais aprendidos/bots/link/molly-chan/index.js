const Discord = require("discord.js");
const client = new Discord.Client({ intents: [ "Guilds", "GuildMembers", "MessageContent", "GuildMessages" ]});
const config = require("/config.json")

module.exports = client

client.on('interactionCreate', (interaction) => {

    if(interaction.type === Discord.InteractionType.ApplicationCommand){
  
        const cmd = client.slashCommands.get(interaction.commandName);
  
        if (!cmd) return interaction.reply(`Error`);
  
        interaction["member"] = interaction.guild.members.cache.get(interaction.user.id);
  
        cmd.run(client, interaction)
  
     }
  })

client.on('ready', () => {
    console.log(`Estou online em ${client.user.username}`)

    client.user.setActivity({ 
        name: 'tutorial youtube',
        type: Discord.ActivityType.Playing
    });
});

client.slashCommands = new Discord.Collection()

require('./handler')(client)

client.login(config.token)