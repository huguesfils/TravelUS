# TravelUS

Welcome to **TravelUS**, your ultimate companion for making trips to the USA more enjoyable and hassle-free. TravelUS brings together essential tools for travelers including a translator, a dollar-euro currency converter, and a tip calculator, all in one intuitive and user-friendly application.

## Features

- **Translator**: Powered by Google Translate API, our translator helps you overcome language barriers by providing instant translations.
- **Currency Converter**: Traveling with different currencies? Our dollar-euro converter makes currency calculations straightforward, ensuring you always get the best value.
- **Tip Calculator**: Understand tipping etiquette in the USA with our tip calculator, which suggests appropriate tip amounts based on your service experience.

## Technology

TravelUS is built using SwiftUI and follows the MVVM architectural pattern, showcasing the latest best practices in iOS development.

## Getting Started

To run TravelUS on your local machine, follow these steps:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourgithubusername/TravelUS.git

2. **Navigate to the project directory**:

    ```bash
   cd TravelUS
    
3. **API Keys**:

TravelUS requires API keys for accessing the Google Translate API and currency conversion services.

- Create a new file named ApiKeys.swift in the Model folder within the Core directory of the project.
- Inside ApiKeys.swift, you'll need to declare your API keys as constants. Here's a template you can follow:

    ```swift
    import Foundation
    
    struct ApiKeys {
        static let translationApiKey = "YOUR_GOOGLE_TRANSLATE_API_KEY"
        static let currencyApiKey = "YOUR_CURRENCY_CONVERTER_API_KEY"
    }

4. **Build and run**:
 
Open the project in Xcode, build and run the application.

## Contributing

TravelUS is an open-source project, and contributions are welcome. Whether you're looking to fix bugs, improve features, or suggest new functionality, your input is valued. Please feel free to fork the repository, make your changes, and submit a pull request.

    
