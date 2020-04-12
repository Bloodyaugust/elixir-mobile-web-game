// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"

(() => {
  const createGameButton = document.getElementById('create-game');
  const gameList = document.getElementById('game-list');
  const startGameButtons = document.querySelectorAll('input.start-game[type="button"]');

  const allGameChannel = socket.channel('game:all', {});

  function newButton(attributes) {
    const newElement = document.createElement('input');
    const typeAttribute = document.createAttribute('type');

    typeAttribute.value = 'button';
    newElement.setAttributeNode(typeAttribute);

    attributes.forEach((attribute) => {
      const newAttribute = document.createAttribute(attribute.type);

      newAttribute.value = attribute.value;
      newElement.setAttributeNode(newAttribute);
    });

    return newElement;
  }

  allGameChannel.on('created', payload => {
    console.log('created', payload)
    const listItem = document.createElement('li');
    const dataIDAttribute = document.createAttribute('data-id');
    const newStartButton = newButton([
      { type: 'class', value: 'start-game' },
      { type: 'data-id', value: payload.body.id },
      { type: 'value', value: 'Start Game' }
    ]);
    const newNextRoundButton = newButton([
      { type: 'class', value: 'next-round' },
      { type: 'data-id', value: payload.body.id },
      { type: 'value', value: 'Next Round' }
    ]);

    listItem.childNodes[0].textContent = payload.body.description;

    dataIDAttribute.value = payload.body.id;
    listItem.setAttributeNode(dataIDAttribute)

    listItem.appendChild(newStartButton);
    listItem.appendChild(newNextRoundButton);

    gameList.appendChild(listItem);

    listenToGame(payload.body.id);
  });

  allGameChannel.join()
    .receive('ok', resp => { console.log('Joined game:all successfully', resp) })
    .receive('error', resp => { console.log('Unable to join', resp) });

  createGameButton.addEventListener('click', () => {
    allGameChannel.push('create', { body: 'do it' });
  });

  function listenToGame(gameID) {
    const startGameButton = document.querySelector(`input.start-game[data-id="${gameID}"]`);
    const nextRoundButton = document.querySelector(`input.next-round[data-id="${gameID}"]`);
    const gameListItem = document.querySelector(`li[data-id="${gameID}"]`);

    const gameChannel = socket.channel(`game:${gameID}`, {});

    gameChannel.on('updated', payload => {
      console.log('updated', payload);
      gameListItem.childNodes[0].textContent = payload.body.state;
    });

    gameChannel.join()
      .receive('ok', resp => {
        console.log(`Joined game:${gameID} successfully`, resp);
      })
      .receive('error', resp => { console.log(`Unable to join game:${gameID}`, resp) });

    startGameButton.addEventListener('click', () => {
      gameChannel.push(`start:${gameID}`, { body: 'do it' });
    });
    nextRoundButton.addEventListener('click', () => {
      gameChannel.push(`next_round:${gameID}`, { body: 'do it' });
    });
  }

  startGameButtons.forEach(button => {
    listenToGame(button.dataset.id);
  });
})();
