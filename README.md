
# WeldAnalysis

[WeldAnalysis](https://github.com/cdaenekas/WeldAnalysis) is a comprehensive toolkit designed to automate the evaluation of weld geometries. This project aims to be utilized in both research and industrial fields to assess weld seam parameters, primarily weld toe radius and weld toe angle, using scan data. The evaluation is crucial for analyzing the fatigue strength of welded joints. Future releases may include the evaluation of additional weld parameters. The project was originally published in connection with the journal paper [(Dänekas et al., 2025)](https://www.sciencedirect.com/science/article/pii/S0143974X2400662X).

## Features

- MATLAB functions for data preparation including data filtering and modifying point distances.
- Evaluation of weld toe radius and weld toe angle using different methods based on two-dimensional weld seam profiles.
- Localization of weld toe by partially derivation of weld profile.
- Example data provided for initial evaluation.
- Included methods for evaluation of weld toe radius: curvature method, least squares method, iteration method
- Included methods for evaluation of weld toe angle: maximum gradient and end point gradient.
- Detailed description of the methods and functionality of the project can be seen in [(Dänekas et al., 2025)](https://www.sciencedirect.com/science/article/pii/S0143974X2400662X).

## Installation

1. Download and unpack the repository.
2. Navigate to the project directory.
3. Open MATLAB and set the current folder to the project directory.
4. Run the main script (`main.m`).

## Compatibility

The codes created for MATLAB R2022b. Therefore this project should be compatible with MATLAB version R2022b and later.

## Usage

- The main file (`main.m`) is an example and should be adjusted to fit individual needs. In the supplied case, ASCII files are read, each containing a single weld section.
- If multiple section information is present in a file, or if the information is in TXT or STL files, adjustments in the main file are required.
- In `loadsettings.m`, settings for data preparation and evaluation methods can be configured.
- All other functions work for two-dimensional sections and can be used as tools without modification.
- The `funcfigresult.m` function for generating result plots should be customized to meet individual preferences.

## Important notes

- Users are responsible for the results.
- A significant part of the analysis is data preparation, which must be customized individually.
- The point data in the area of the base material must have the same y-coordinates and must not be inclined. 
- This repository is not a comprehensive program but a toolkit.
- Users must verify the accuracy of the results.
- The quality of the scan files must be checked and should meet the requirements recommended in the paper (DOI to be added later).

## Versioning

We use semantic versioning. For the versions available, see the [tags on this repository](https://github.com/cdaenekas/WeldAnalysis/tags).

**Current Version**: 1.0.0

## Contributing

- Users are welcome to use the toolkit in accordance with the license.
- Proper acknowledgment and citation in papers are required. See the [CITATION](CITATION.cff) file, to cite the project. Additionally, users are encouraged to cite the related [journal paper](https://www.sciencedirect.com/science/article/pii/S0143974X2400662X).
- We also welcome contributions and further developments to the project on github, using a fork. Information can be found in the [github documentation](https://docs.github.com/de/pull-requests).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE.lic) file and [github documentation](https://choosealicense.com/licenses/mit/) for details.
We still care about sharing improvements and encourage everyone to make newer versions open source.

## Contact Information

For any questions or issues, please contact me on LinkedIn. Links can be found [here](https://github.com/cdaenekas).

