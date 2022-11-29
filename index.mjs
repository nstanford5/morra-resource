import { loadStdlib, ask } from '@reach-sh/stdlib';
import * as backend from './build/index.main.mjs';
const stdlib = loadStdlib();

console.log('Welcome to Morra');

const isAlice = await ask.ask(
  `Alice, is that you?`,
  ask.yesno
);

const who = isAlice ? 'Alice' : 'Bob';

console.log(`Starting Morra as ${who}`);

const createAcc = await ask.ask(
  `Would you like to create an account?`,
  ask.yesno
);

let acc = null;
if(createAcc){
  // create new test account and fund with 1000 tokens
  acc = await stdlib.newTestAccount(stdlib.parseCurrency(1000));
} else { // import account from secret mnemonic
  const secret = await ask.ask(
    `What is your account secret?`,
    (x => x)
  );
  acc = await stdlib.newAccountFromSecret(secret);
}

// who is it?
// deploy or attach accordingly
let ctc = null;
if (isAlice){
  ctc = acc.contract(backend);
  ctc.getInfo().then((info) => {
    console.log(`The contract is deployed = ${JSON.stringify(info)}`);
  });
} else {
  const info = await ask.ask(
    `Please paste the contract information`,
    JSON.parse
  );
  ctc = acc.contract(backend, info);
}

const fmt = (x) => stdlib.formatCurrency(x, 4);
const getBalance = async () => fmt(await stdlib.balanceOf(acc));

const before = await getBalance();
console.log(`Your balance is ${before}`);

const interact = { ...stdlib.hasRandom };

const HAND = [0, 1, 2, 3, 4, 5];
const GUESS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

interact.informTimeout = () => {
  console.log(`There was a timeout`);
  process.exit(1);
};

if(isAlice) {
  const amount = await ask.ask(
    `How much do you want to wager?`,
    stdlib.parseCurrency
  );
  interact.wager = amount;
  interact.deadline = {ETH: 100, ALGO: 100, CFX: 1000}[stdlib.connector];

} else { // must be Bob
  interact.acceptWager = async (amount) => {
    const accepted = await ask.ask(
      `Do you accept the wager of ${fmt(amount)}`,
      ask.yesno
    );
    if(!accepted){
      process.exit(0);
    }
  };
}

interact.getHand = async () => {
  const hand = await ask.ask(`What hand will you play? (0-5 only)`);
  console.log(`You played ${hand}`);
  return hand;
};

interact.getGuess = async () => {
  const guess = await ask.ask(`What is your guess for the total?`);
  console.log(`You guessed ${guess} total`);
  return guess;
};

interact.seeActual = (winningNum)  => {
  console.log(`The actual winning number is: ${winningNum}`);
};

const OUTCOME = ['Alice wins!', 'Bob wins!', 'Draw'];
interact.seeOutcome = (outcome) => {
  console.log(`The outcome is ${OUTCOME[outcome]}`);
};

const part = isAlice ? ctc.p.Alice : ctc.p.Bob;
await part(interact);

const after = await getBalance();
console.log(`Your balance is now ${after}`);

console.log('Goodbye, Alice and Bob!');

ask.done();