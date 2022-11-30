'reach 0.1';

const [gameOutcome, A_WINS, B_WINS, DRAW] = makeEnum(3);

// function that computes the winner based on hands and guesses
const winner = (fingersA, fingersB, guessA, guessB) => {

  // if both guesses are the same
  if (guessA == guessB) {
    return DRAW;
  } else {
    // if first player guess is equal to total of both hands played
    if (guessA == (fingersA + fingersB)) {
      return A_WINS;
    } else {
      // if second player guess is equal to total of both hands played
      if (guessB == (fingersA + fingersB)) {
        return B_WINS;
        // else the outcome is a draw
      } else {
        return DRAW;
      }
    }
  }
};

// the asserts give the forall indicators as to expected outcomes
// can work with any value, we are more concernced with all
// possible combinations of the game outcome given inputs
// what are the different possibilities of inputs?
assert(winner(_, _, _, _) == B_WINS);
assert(winner(_, _, _, _) == A_WINS);
assert(winner(_, _, _, _) == DRAW);
assert(winner(_, _, _, _) == DRAW);

// assert for all possible combinations of inputs
forall(_, _ =>
  forall(_, _ =>
    forall(_, _ =>
      forall(_, _ =>
        assert(gameOutcome(winner(_, _, _, _)))))));

// assert for all possible hands where guesses are the same

// shared player method signatures
const Shared = {
  ...hasRandom, 
  getFingers: Fun([], UInt),
  getGuess: Fun([UInt], UInt),
  seeOutcome: Fun([UInt], Null),
  informTimeout: Fun([], Null),
};

// Reach app starts here
export const main = Reach.App(() => {

  // participant interact interface
  const Alice = Participant('Alice', {
    // inherit all Player functions here
    // declare wager here 

    // declare deadline here
  });

  // participant interact interface
  const Bob = Participant('Bob', {
    // inherit all Player functions here
    // declare acceptWager function signature
  });

  // initialize the app
  init();

  const informTimeout = () => {
    each([Alice, Bob], () => {
      interact.informTimeout();
    });
  };

  // In a local step, Alice only provides the wager and the deadline here

  // Alice publishes this information and pays the wager here
  
  // commit moves us back to step
  commit();

  // In a local step, Bob only interacts with the acceptWager function
  

  // Bob pays the wager, use a timeout here relative to deadline

  var outcome = DRAW;
  // invariant must be true after the execution of the while loop
  // has the balance of the contract stayed the same?
  // is the outcome valid against enumerated type gameOutcome?
  invariant();

  // while the outcome is still a draw, continue to loop
  while ( outcome == DRAW ) {
    commit();

    // Alice only in a local step gets information related to the hand and guess
    // Both values here should make use of the Reach cryptographic commitment scheme

    // publish commitment to hand and commitment to guess value, use a timeout relative to
    // the deadline here
    
    commit();

    // Bob cannot know these values at this state
    unknowable();
    unknowable();

    // Bob only in a local step gets information related to their hand and guess
    // this information can be declassified

    // Bob publishes this information, use a timeout here relative to the deadline
    
    commit();

    // Alice can reveal their info in a local step

    // Alice can publish unhashed values for salts and values
    // use a timeout here relative to deadline
    
    //checkCommitment only takes 3 values
    checkCommitment(_, _, _);
    checkCommitment(_, _, _);


    // update loop variable by passing values to winner function

    // explicit continue, must be the tail here
    continue;
  }; // end of while loop

  // assert the outcome is A_WINS or B_WINS

  // transfer 2 * wager to winning player
  
  commit();

  // show each player the outcome
  each([Alice, Bob], () => {
    interact.seeOutcome(outcome);
  });
  exit();
});