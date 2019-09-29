# Rotom Bot
<img align= 'right' width="300" src= "https://d111vui60acwyt.cloudfront.net/product_photos/53054708/52_Rotom_original.png">
_The best ghosty-electric boy that runs your devices!_

This bot was created for use in the Pokemon Mystery Dungeon, Kink Teams Discord.
It manages users, characters, items and places in a fictional world full of
Pokemon. This bot works in junction with webhooks, to recieve information
submitted via google forms.

To collaborate on this project, create and work on a branch. Don't forget to
list new features in the list below. When you are ready to merge your branch,
you may create a pull request at [ajsw.is](https://code.ajsw.is/PMD/rotom_bot)

```bash
$ git checkout -b [branch_name]       #to create a branch
$ git push origin  branch_name]       #to push branch
```

### Features
  * Says Hello
  * Displays Type Matchups

## Setup
This application runs using Ruby and Postgres. In order to run the bot locally
you can create a bot in the discord developer portal and use it to test

To pull in the project, we'll navigate where we want to keep the project in a
terminal

```bash
$ cd [directory\ name]  # 'cd' changes directory, and if it has spaces '\' is the escape character
```

once there we clone the project!

```bash
$ git clone git@code.ajsw.is:PMD/rotom_bot.git
```

### Prereqs
  * __Installing [RVM](https://rvm.io/rvm/install) and Ruby__

    We can Install RVM and Ruby with the following:

    ```bash
    $ \curl -sSL https://get.rvm.io | bash -s stable
    $ rvm install ruby 2.6.3
    ```

    If you are a windows user, you can follow my [guide](#how-to-setup-rvm-for-windows-users)

  * __Install Bundler and Bundle Install__

    ```bash
    $ gem install bundler
    $ bundle install
    ```

  * __Setup Environment Variables__

    For this step, we're going to copy the `.env.template` and create a `.env`
    from it.

    The first 3 variables are related to the database, and the last 3 are
    related to the bot

  * __Setup Postgresql__

    For installation, documentation, and setup instructions
    visit [postgresql.org](https://www.postgresql.org/download/)

    We need to create a user and database for the bot to use. The actual user
    and Database names don't matter so create them, and use them to fillout a
    `.env` file in the root of the project

    ```sql
    CREATE USER [name] WITH PASSWORD '[password]';
    CREATE DATABASE [name] WITH OWNER [username];
    ```

    If the db gets created with initail setup this is how to change owner

    ```sql
    ALTER DATABASE [name] OWNER TO [new_owner];
    ```

  * __Create Test Bot__
    To run your code, we need a bot! You can create one through the
    [Discord Developer Portal](https://discordapp.com/developers/applications/)

    Create a new project, and name it whatever you want. We're going to need 3
    codes from there. **Client ID** and **Client Secret** are on the `General
    Information` page, and the last code we need is on the `Bot` page. Simply
    create a bot here, and copy its **Token**


  * __Run the bot__

    Now our setup is complete, and you should be able to run the bot!

    ```bash
    $ ruby bot.rb
    ```

## How to setup RVM for Windows Users
  * __Enable Developer Mode__

    Open your settings, and navigate to Update and Security

    On the left, click `For Developers`, and check `Developer Mode`

  * __Subsystem for Linux__

    Next open the Control Panel, and select `Programs`
    and select `Turn Windows features on or off` on the side bar

    Search for `Windows Subsystem for Linux`, check it and wait for the
    install, then restart

  * __Installing bash__

    Now you can open a Command Prompt and type in:
    ```
    C:\Users\YourUserName> bash
    ```
    If it returns saying you have no installed distributions, open up the
    Microsoft Store and install Ubuntu (its free), and try again

    If it is asking for verification, reply with `y` and wait for the install

    Once prompted you can provide a username and password of your choice, you
    should then get a prompt:

    ```bash
    username@ComputerName: $
    ```

  * __Installing [RVM](https://rvm.io/rvm/install) and Ruby__

    We need to install GPG, and get a public key
    , install RVM, access the command and then use it to install Ruby

    ```bash
    $ sudo apt-get install gpg
    $ gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    ```

    We can Install RVM and Ruby with the following:

    ```bash
    $ \curl -sSL https://get.rvm.io | bash -s stable
    $ source ~/.rvm/scripts/rvm
    $ rvm install ruby 2.6.3
    ```


