# Codeshare.io Clone

A complete Codehshare.io clone made in Flutter and Nodejs, Works on Web , Android , iOS and Desktop

## Features

- Google/Guest Authentication
- Code with your team
- Interview developers
- Teach people to program
- Share Code in Real-time with Developers
- CODE URL Link sharing
- Auto saving
- Collaborative Editing in Rich Code Editor
- State Persistence
- Creating new Code documents
- Viewing List of Your Codes (Note: YOu must be authenticated)

## Demo

Plese take a look on live version [codeurl.web.app](https://codeurl.web.app)

<p align="center">
  <img width="600" src="https://media.giphy.com/media/73AtaZ4NBzxDQVosrP/giphy.gif" alt="Codeurl.web.app">
</p>
<p align="center">
  <img width="600" src="https://media.giphy.com/media/J5L83gyPJBABJfrppk/giphy.gif" alt="codeurl.web.app">
</p>
<p align="center">
  <img width="600" src="https://media.giphy.com/media/5hZoZmOhQRTrJ1iEfv/giphy.gif" alt="codeurl.web.app">
</p>

## Installation

After cloning this repository, migrate to `` folder. Then, follow the following steps:

- Create Google Cloud Project
- Enable Oauth for Web, Android and iOS
- Add google-signin-client_id in web and google-services json fle in Android and iOS.
  Then run the following commands to run your app:

```sh
  git clone https://github.com/ankitRay1/codeshare.io.clone

  #install flutter plugins
  flutter pub get

  # Run in Web
  flutter run -d chrome --web-port=4000

  #Run in Android and iOS
  flutter run
```

## Tech Used

**Server**: Nodejs, Express, MongoDB, Mongoose, SocketIO

**Client**: Flutter, Riverpod 2.0, Routemaster

## Backend

NodeJS codes can be found on another repository @codeshare.io.api.
[Server Codebase](https://github.com/ankitRay1/codeshare.io.api)

## Feedback

If you have any feedback, please reach out to me at ankitdeveloperconsole@gmail.com
