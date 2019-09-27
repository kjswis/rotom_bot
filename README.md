# Rotom Bot
_The best ghosty-electric boy that runs your devices! He's also your
friendly Pokemon Myster Dungeon Bot <3_

## Setup
This application runs using Ruby and Postgres. In order to run the bot locally
you can create a bot in the discord developer portal and use it to test

### Windows Users
  * __Enable Developer Mode__

    Open your settings, and navigate to Update and Security

    On the left, click `For Developers`, and check Developer Mode

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

### Prereqs
  * __Installing [RVM](https://rvm.io/rvm/install) and Ruby__

    If you are on Windows, we need to install GPG, and get a public key
    , install RVM, access the command and then use it to install Ruby

    ```bash
    $ sudo apt-get install gpg
    $ gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    ```

    We can Install RVM and Ruby with the following:

    ```bash
    $ \curl -sSL https://get.rvm.io | bash -s stable
    $ rvm install ruby 2.6.3
    ```

    On Windows we need to access the command before we can use it, so use this command between the two above

    ```bash
    $ source ~/.rvm/scripts/rvm
    ```

  * __Install Bundler and Bundle Install__

    ```bash
    $ gem install bundler
    $ bundle install
    ```

  * __Setup Postgresql__

    For Installation and setup instructions visit [postgresql.org](https://www.postgresql.org/download/)

    Create a user and database

    Use the `.env.template` to make an `.env` with the appropriate information

    If you are making a development bot, use the information from the discord developer portal

  * __Run the bot__

  ```bash
  $ ruby bot.rb
  ```
