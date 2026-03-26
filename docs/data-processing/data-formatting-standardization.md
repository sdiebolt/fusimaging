---
icon: lucide/file-badge
---

# A Word on Data Formatting and Standardization

## Why standardization matters for fUSI

Functional ultrasound imaging (fUSI) has rapidly evolved over the past decade, with a growing number of researchers adopting this technology for neurovascular imaging. As the field matures, the need for standardized data formats becomes increasingly critical. Standardization offers several important benefits:

- **Facilitates collaboration** by making it easier to share datasets between labs and institutions.
- **Enhances reproducibility** by providing a clear structure for data organization.
- **Accelerates analysis workflow development** through consistent file naming and organization.
- **Improves data discoverability and reuse** by enabling the use of platforms such as [OpenNeuro](https://openneuro.org/).
- **Enables integration with [existing neuroimaging tools](https://bids-apps.neuroimaging.io/)** by adopting compatible formats.

## The fUSI-BIDS initiative

The [Brain Imaging Data Structure (BIDS)](https://bids-specification.readthedocs.io/en/stable/) is a widely adopted standard in neuroimaging that specifies how to organize and describe fMRI, MEG, EEG, and other data types. To extend these benefits to the fUSI community, a [BIDS Extension Proposal (BEP040)](https://docs.google.com/document/d/1W3z01mf1E8cfg_OY7ZGqeUeOKv659jCHQBXavtmT-T8/edit?tab=t.0#heading=h.4k1noo90gelw) is currently being developed to standardize how fUSI datasets should be structured.

The fUSI-BIDS specification aims to standardize collections of ultrafast power Doppler scans acquired using any functional ultrasound system. This extension inherits core principles from the original BIDS specification while addressing the unique requirements of fUSI data.

## Key features of fUSI-BIDS

### Data types and organization

fUSI-BIDS defines two primary data types:

- **fusi**: Task-based and resting-state functional ultrasound imaging.
- **angio**: Angiographic scans for visualization, neuronavigation, or registration.

Data is organized hierarchically by subject, optional session, and data type:

```
projectName/
├── dataset_description.json
├── participants.tsv
└── sub-<label>/
    └── [ses-<label>/]
        ├── angio/
        │   └── sub-<label>[_ses-<label>][_entities]_pwd.nii[.gz]
        └── fusi/
            └── sub-<label>[_ses-<label>]_task-<label>[_entities]_pwd.nii[.gz]

```

### Scanner coordinate system

A feature of fUSI-BIDS is the definition of a standardized scanner coordinate system to ensure proper spatial registration across multiple acquisitions. The scanner space is defined with:

- Origin at the center of the probe's surface at its first pose.
- (x, y, z) axes corresponding to (azimuth, elevation, axial) in a right-handed system.
- Unit of measure in millimeters.

### Handling sparse spatial sampling

Unlike MRI, fUSI often involves acquiring data at sparse spatial locations by moving the probe. fUSI-BIDS addresses this through:

- The **pose entity** (`pose-<index>`) to identify multiple probe positions within an acquisition.
- NIfTI file format to store the data with appropriate coordinate transformations.
- Storage of affine transformations in the NIfTI header's qform field.

### Comprehensive metadata

The specification defines extensive metadata fields to document:

- Scanner and probe hardware specifications.
- Sequence specifics (angles, frequency, depth).
- Clutter filtering parameters.
- Power Doppler integration settings.
- Timing information.
- Task and protocol details.

## Getting started with fUSI-BIDS

If you're interested in adopting fUSI-BIDS for your research, here are some resources to help you get started:

1. **Learn about BIDS**: The [main BIDS specification](https://bids-specification.readthedocs.io/en/stable/) provides detailed information about the common principles used to structure datasets according to BIDS.
2. **Review the fUSI-BIDS proposal**: The [fUSI-BIDS specification document](https://docs.google.com/document/d/1W3z01mf1E8cfg_OY7ZGqeUeOKv659jCHQBXavtmT-T8/edit?tab=t.0) details how to extend BIDS for fUSI.
3. **Explore example datasets**: Example datasets demonstrating proper fUSI-BIDS organization are available in the [fUSI-BIDS examples repository](https://github.com/sdiebolt/fusi-bids-examples). You may also want to look at [BIDS examples from other modalities](https://github.com/bids-standard/bids-examples). 
4. **Use conversion tools**: Tools are being developed to help convert existing fUSI data to the BIDS format.
5. **Contribute to the standard**: The fUSI-BIDS specification is a community effort. Feedback and contributions are welcome to improve the standard. Regular meetings are organized every two months.

## Why adopt fUSI-BIDS now?

While the fUSI-BIDS specification is still under development (currently at version 0.0.11), there are compelling reasons to start adopting it:

1. **Future-proofing your data**: Organizing data according to the emerging standard now will make future transitions easier.
2. **Contributing to the standard**: Early adopters can help shape the specification by providing feedback based on real-world usage.
3. **Building interoperable tools**: Developing analysis pipelines based on a standardized format enables sharing of tools across the community.
4. **Facilitating reproducible research**: Standard data organization makes methods sections more precise and results more reproducible.

The fUSI field is at a critical juncture where standardization can significantly accelerate progress. By adopting common practices for data organization now, we can collectively build a more robust ecosystem for functional ultrasound imaging research.

## Beyond fUSI-BIDS: the fUSIer zen

Standardization is always confronted to a steep learning curve. If you have your own naming protocol, why bother changing it ? In addition to all the reasons listed above: easy sharing with your collaborators, possibility to use existing tools without thinking about it, possibility to use others data easily…. Always remember that by making this effort for others you are working for yourself. Because many people, from fMRI with the main BIDS and fUSI with our BEP have been giving some thoughts about it, you will realize using it how easier is life when your data are fUSI-BIDS compliant.  

**For experimenters,** there will be no wondering about file names no more, forget about these:

```
experiment_01/
├── stim_01HZ_amp10V.data
├── stim_01HZ_amp10V_bis.data
├── stim_01HZ_amp10V_bis_different.data
├── stim_01HZ_amp10V_bis_different-test.data
├── stim_01HZ_amp10V_bis_01.data
└── stim_01HZ_amp10V_bis_01a.data
```

Embrace naming determinism and just give your files the name they deserve, which solely depends of what you did during the experiment. 

**For analysts,** it is finished the era of 8 days copying 4 times the datasets to extract your groups before running your t-test. Just parse your dataset with the relevant metadata fields and adapt automatically your analysis parameters to each recording specificities.

Ultimately using fUSI-BIDS should help you plan your experiment by translating directly your experimental question into a data structure that you just fill with the data you acquire. By doing so you remove the burden of improvisation during the experiment which propagates during the analysis, and you can start your imaging campaign with a relaxed mind.

We acknowledge that this sound all cheesy vanilly… And these extended (but human readable) filenames can be overwhelming at first. So if you are willing to make the jump, or if you got lost in the middle of it, don’t hesitate to contact us on the [fUSI-BIDS discord channel](https://discord.gg/AmS46Vmq). 
