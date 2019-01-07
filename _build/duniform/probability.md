---
title: 'Random Variables and Probability'
prev_page:
  url: /duniform/introduction
  title: 'Discrete Uniform Distribution'
next_page:
  url: /bernoulli/introduction
  title: 'Bernoulli Distribution'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---
# Random Variables and Probability

## Dice

Die are easy to think about, because we've all rolled a die before and
we all think we know what we mean when we say the probability of
rolling a $1$ is $1/6$.  Throughout this section, don't let this
intuition go.  Rather expand upon it to the more detailed
descriptions below.

## Random Variable

A **random variable** is a function from an **event** to a
numerical value.  Note that the randomness is not, per se, part of the
random variable.  The randomness is instead found in the underlying
process that the random variable is meant to quantify.

A die is especially easy to think about, but
for clarity let's imagine a die labeled with the letters $A, B, C,
D, E, F$ instead of the numbers $1, 2, 3, 4, 5, 6$.  As far the
events go, rolling an $A$ will still happen with probability $1/6$.
This special die helps us separate the distinct pieces
of random variables.  With this special die, we have events -- any value of
interest that a die might turn up -- and values produced by the random
variable associated with those events.  In notation, we might write
$X(A) = 1$, $X(B) = 2, \ldots, X(F) = 1$.

In mathematical statistics, we read $X \sim Uniform(\\{A, B, C,
D, E, F\\})$, the random variable $X$ follows a
**discrete** Uniform distribution on the set $\\{A, B, C, D, E, F\\}$.
If you're content to keep numbers on your die to enable cleaner
notation we read $X \sim \text{Uniform}(1, 6)$, the random
variable $X$ follows a **discrete** Uniform distribution on the set
$\\{1, 2, 3, 4, 5, 6\\}$.  Notice that the notation $\text{Uniform}(1,
6)$ implies the integer values in between $1$ and $6$.  The latter
notation is more common.

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
willing to drop the events $\{H, T\}$ from our notation.  Next, we
will consider what the following mathematical statements means, in
an operational sense, $P(X \in \\{ H \\}) = 1/2$.

## Probability

Retired professor [M. K. Smith](https://web.ma.utexas.edu/users/mks/statmistakes/probability.html)
provides a nice survey of the various notions of the probability of an
event.  This book will focus on an empirical version of probability
that goes as follows.

The probability of an event $E$ is the limiting relative frequency of
the occurrences of $E$ over the number of trials,

$$ P(X \in E) = \lim_{n \rightarrow \infty} \frac{1(X \in E)}{n},$$

where $1(X \in E)$ takes on the value $1$ any time the random variable
$X$ is in the event $E$ and $0$ otherwise.  We interpret probability
as if the process that produces $X$ were repeated (thus assuming
repeatability) an infinite number of times.  In terms of a fair coin,
$P(X \in \\{H\\}) = 1/2$ implies that we believe that flipping a fair
coin an infinite number of times would witness one half of the flips
to produce head.
