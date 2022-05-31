# Preface

```{warning}
This is an ongoing, incomplete project.
```

The 20th century economics witnessed the establishment of a mathematical framework of analysis. In the 21st century empirical economic studies have grown into a  dominating force.
Programming is an essential skill for empirical researchers in economics.
As a response to postgraduate students' repeatedly requests, I started to offer this course in 2015 to train them in coding skills.

I believe the best way to learn programming is to follow examples. These notes contain executable examples in R to illustrate econometric computational ideas.

Econometrics is interdisciplinary study involving economics, statistics, operational research, and computer science. No matter how beautiful is the theory,
it will be of little use if it cannot be implemented. Thus econometric procedures must be accompanied with computational code. While many existing methods
are encapsulated in canned packages, new methods must be developed by econometricians themselves.

Open source software is indispensable for our daily work, for example, Linux, R, Python and LaTeX.
Offering code for free is a good way to facilitate adoption of new methods.

These lecture notes are products of an ongoing writing project.
They are not intended to be comprehensive, as I don't want to reinvent wheels.
I refer to the relevant papers and surveys when there are excellent writings for mature topics.

## Personal Reflection

Forty years ago aspiring young econometricians picked up GAUSS.
Thirty years ago the new blood began with MATLAB.
R raised twenty years ago when the time came to my generation.
I have been using R since I since 2005.
R helps me with my daily research and teaching.

R has many advantages as an excellent data science language.
First, it inherits the standard program syntax. It is quick to learn for anyone with prior programming experience.
Moreover, once you master R, it is easy to switch to other language, if not R, in your workplace in the future.

Second, backed by a vast statistician community, R enjoys a large selection of packages, including the most recent ones.
When they publish a paper, often times statisticians write and upload a companion R package to facilitate user adoption.
R is nowadays used widely in tech companies to boost real productivity.

Third, R is free.
It was the primary reason that I chose it at the very beginning.
In the era of cloud computing, an algorithm written in R is easier to share, test, and improve.
Anyone can run R code on any platform, free of license and fee headache.

R is not without limitations. For example, speed is a concern when running large and complex jobs.
However, it will not be an issue in the problems that we will encounter in the first-year postgraduate study.

Lastly, learning a language is a non-trivial investment of our precious time.
It is much more important to master one language with fluency than to know several languages.

R is not the only language available for computing. Why not Python?
Python is a general purpose language, not a scientific computing language.
We need to import external modules even for the most basic numerical operations.
For example, I personally don't like `np.mean`, `np.var` and `np.linalg.solve`.
For basic matrix manipulation, the default behavior of `numpy` is different from R (row-wise vs. column-wise).

Why not Julia? Julia is too young to have a big community.
We would wait until it grows into more stable status.
Moreover, the speed advantage does not help much in interactive usage in empirical research.

Over the years, I have had a taste of both Python and Julia.
In my opinion, R so far best suits our purpose of learning a computing language for statistics and econometric analysis.

I was an expert in MATLAB, which is proprietary. The numerical works of  my first few papers were conducted on MATLAB. However, I was never a fan of MATLAB's syntax, in particular its ugly way to put arguments into functions.
MATLAB may still linger in some areas in engineering, but it will be a dinosaur fossil buried under the wonderland of big data.

## Structure

The book version can be partitioned into three parts: R, Econometrics, and Machine Learning.

The first two lectures cover basic R and advanced R. Advanced R taught skills about speeding up matrix manipulation, parallel computing and remote computing.
The following two lectures cover simulation exercises and simulation-based methods in econometrics.
The last two lectures talk about machine learning methods. Machine learning is relatively new for economists. Most economics programs only introduce a few
algorithms but do not cover the theoretical components. We try to provide a review starting from the conventional nonparametric statistical methods.
<!-- 
## Packages

```{r}
install.packages(c("plyr", "foreach", "doParallel",
                   "sampleSelection", "AER", "mcmc",
                   "randomForest", "gbm"))
``` -->
