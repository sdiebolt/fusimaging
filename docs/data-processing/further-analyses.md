---
icon: lucide/chart-no-axes-combined
---

# Further Analyses

Once you are done with preprocessing your data and it is as clean as it can be, you can
start data analysis! As this will highly depend on the scientific question, we will not
write an exhaustive list of all the analyses one can do. However, we will go over the
most common analyses directions.

If we are interested in changes in cerebral blood volume throughout time, we typically
want to ignore differences in baseline blood volume across voxels. This is why a common
first step is to normalize the signal, like we would do with fluorescence imaging.  This
can be done by, for each voxel, z-scoring the signal through time, or subtracting and
dividing by the mean, either in sliding windows, or in specific windows (e.g. baseline
before a stimulus presentation or an event). 

## Functional connectivity

**Functional connectivity (FC)** is a subfield of neuroimaging which emerged at the end
of the 90’s. It relies on the analysis of haemodynamic second order statistics. In other
words, we measure the correlation between two signals coming from two distinct regions
of the brain to evaluate how much they are connected. Because haemodynamic signal is
intrinsically limited by neurovascular coupling, FC relies on the analysis of infraslow
signal $<0.1Hz$ , which has been reported to bring most of the energy of these signals.
Historically, FC analysis consists in the computation of connectivity maps or
connectivity networks over long periods of time framed as static FC. More recently, many
scientists have started investigating what happens for shorter periods of time in the
infraslow fluctuations. This new field of **dynamic Functional Connectivity (dFC)** is
now growing fast, bringing new insights on how the brain works, but also mechanisms
underlying conventional static FC.

We detail in the page below the fundamental principles and resulting hypotheses
underlying functional connectivity.

[Functional Connectivity Theory and
principles](further-analyses/functional-connectivity.md)

We present in the page below how these hypotheses translate into specific processing of
the data required for FC analyses.

[Implementation of rs-FC](further-analyses/implementation-rs-fc.md)

## Response to stimuli

Standard protocols involve presenting stimuli to the animal (visual, auditory, tactile,
etc.). The signal is then aligned or cross-correlated with stimuli events (onsets, for
example).
