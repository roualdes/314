# Random Variables and Probability

## Dice

Die are easy to think about, because we've all rolled a die before and
we all think we know what we mean when we say the probability of
rolling a $1$ is $1/6$.  Throughout this section, don't let this
intuition go.  Rather expand upon it to the more detailed
descriptions below.

In this section we'll use some new words.  As a warm up, let's introduce a few new words based on the easy to think about dice example.

- [**Experiment**](https://en.wikipedia.org/wiki/Experiment_(probability_theory)): An occurrence with an uncertain outcome that we can observe. 
For example, rolling a die.
- [**Outcome**](https://en.wikipedia.org/wiki/Outcome_(probability)): The result of an experiment; one particular state of the world. Sometimes called a "case."  
For example: $4$.
- [**Sample Space**](https://en.wikipedia.org/wiki/Sample_space): The set of all possible outcomes for the experiment.  
For example, $\\{1, 2, 3, 4, 5, 6\\}$.
- [**Event**](https://en.wikipedia.org/wiki/Event_(probability_theory)): A subset of possible outcomes that together have some property we are interested in.  
For example, the event "even die roll" is the set of outcomes $\\{2, 4, 6\\}$.
- [**Probability**](https://en.wikipedia.org/wiki/Probability_theory): As [Pierre-Simon Laplace](https://en.wikipedia.org/wiki/Pierre-Simon_Laplace) said, the probability of an event with respect to a sample space is the number of favorable cases (outcomes from the sample space that are in the event) divided by the total number of cases in the sample space. (This assumes that all outcomes in the sample space are equally likely.) Since it is a ratio, probability will always be a number between 0 (representing an impossible event) and $1$ (representing a certain event).  
For example, the probability of an even die roll is $3/6 = 1/2$.

The specific definitions aboves come from Peter Norvig's [A Concrete Introduction to Probability (using Python)](https://nbviewer.jupyter.org/url/norvig.com/ipython/Probability.ipynb), which is a great resource if you want more information about the basics of probability.

## Random Variable

A **random variable** is a function from abritrary sets of the **sample space** to a numerical value.  Despite the name, the randomness is not, per se, part of the variable.  The randomness is instead found in the underlying
process that the random variable is meant to quantify.

A die is especially easy to think, because it maps so well to a random variable.  But for the sake of clarity, let's imagine a die labeled with the letters $A, B, C,
D, E, F$ instead of the numbers $1, 2, 3, 4, 5, 6$.  As far the
events go, rolling an $A$ will still happen with probability $1/6$; there's only one $A$ and $6$ possible outcomes, hence $1/6$.
This special die helps us separate the distinct pieces
of random variables.  With this special die, we have events -- any value of
interest that a die might turn up -- and values produced by the random
variable associated with those events.  In mathematical notation, we might write
$X(A) = 1$, $X(B) = 2, \ldots, X(F) = 6$.

In mathematical statistics, we read $X \sim Uniform(\\{A, B, C, D, E, F\\})$, the random variable $X$ follows a
**discrete** Uniform distribution on the set $\\{A, B, C, D, E, F\\}$.
If you're content to keep numbers on your die to enable cleaner
notation we read $X \sim \text{Uniform}(1, 6)$, the random
variable $X$ follows a discrete Uniform distribution on the set
$\\{1, 2, 3, 4, 5, 6\\}$.  Notice that the notation $\text{Uniform}(1,
6)$ implies the integer values from $1$ to $6$, inclusive.  The notation $X \sim \text{Uniform}(1, 6)$ is more common.

In fact, it's common to drop the argument to the random variable,
which is really a function, entirely.  More often interest lies in the
probability of events.  For example, we might be interested in the
probability that either $A, B,$ or $C$ turn up.  Let $E = \\{1, 2, 3\\}$
be the event that an $A, B$, or $C$ turns up in one roll.  We read
$P(X \in E)$ what is the probability that we roll one of $A, B,$ or
$C$.  At a certain point, the argument to $X$ just gets in the way
since the notation $P(X \in E)$ equally applies to a die labeled with
letter or numbers.

Consider another random variable, also named $X$.  Let $X \sim U(0,
1)$ be a discrete Uniform random variable on the numbers $0$ and $1$.
Note that this could reasonably represent a fair coin, since we are
willing to drop the events $\{T, H\}$ from our notation.  Next, we
will consider what the following mathematical statements means, in
an operational sense, $P(X \in \\{ H \\}) = 1/2$.

## Probability

Retired professor [M. K. Smith](https://web.ma.utexas.edu/users/mks/statmistakes/probability.html)
provides a nice survey of the various notions of the probability of an
event.  This book will focus on an empirical version of probability
that goes as follows.

The probability of an event $E$ is the limiting relative frequency of
the occurrences of $E$ over the number of experiments $N$,

$$ P(X \in E) = \lim_{N \rightarrow \infty} \sum_{n=1}^N \frac{1(X_n \in E)}{N},$$

where $1(X \in E)$ takes on the value $1$ any time the random variable
$X$ is in the event $E$ and $0$ otherwise.  We interpret probability
as if the process that produces $X$ were repeated (thus assuming
repeatability) an infinite number of times.  In terms of a fair coin,
$P(X \in \\{H\\}) = 1/2$ implies that we believe that flipping a fair
coin an infinite number of times would witness one half of the flips
to produce head.

## Probability in practice

Statistic attempts to approximate probabilities defined with respect to random variables.  The most common approximation strategy, relative to the theoretical definition of probability above, is to simply drop the limit.  Let's define an approximation $\hat{P}(X \in E)$ to $P(X \in E)$ above.

$$ \hat{P}(X \in E) = \sum_{n=1}^N \frac{1(X_n \in E)}{N}$$

In practice, we might let $X$ represent a coin.  If we are interested in the event of flipping a heads, then we might flip this coin $N$ times and add up the total number of heads and divide by the total number of experiments.  Take the time to notice that this is exactly what the $\hat{P}$ notation is saying mathematically.