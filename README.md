## Rick & Morty App README

### Overview

The Rick & Morty App is a Flutter-based mobile application that showcases characters and adventures from the popular animated series, Rick & Morty. This application demonstrates modern mobile development practices using the Flutter framework, combined with a serverless backend architecture powered by AWS services.

### Setup Instructions

#### Prerequisites

Before setting up the application, ensure you have the following installed and configured:

- **Flutter SDK:** Ensure you have the version 3.22.0 of Flutter installed.
- **AWS Account:** You will need an active AWS account to deploy backend services.
- **AWS CLI:** Install and configure the AWS Command Line Interface (CLI) with your AWS credentials.
- **Android Studio / Xcode:** Depending on your target platform, install either Android Studio for Android development or Xcode for iOS development.
- **Git:** Ensure you have Git installed to clone the repository.

#### Frontend Setup

1. Clone the repository:

```bash
git clone https://github.com/magno-castro/rick_morty_app.git
```

2. Navigate to the project directory:

```bash
cd rick_morty_app
```

3. Set ENV variables in `.env` file:

```bash
API_URL=<AWS_API_GATEWAY_BASE_URL>
```

4. Install dependencies:

```bash
flutter pub get
```

5. Run the application:

```bash
flutter run --dart-define-from-file=.env
```

6. Run the tests:

```bash
flutter test
```

### Backend Services

The backend services are built using AWS Lambda functions. Below are the main functions utilized in the application:

- **GetCharacters:** Fetches a list of characters from the Rick & Morty API.
- **GetCharacterById:** Retrieves detailed information about a specific character.
- **FilterCharacters:** Allows users to filter characters based on name of the character.
- **CreateCharacter:** Allows users to create a new character.
- **UpdateCharacter:** Enables users to update an existing character.
- **DeleteCharacter:** Allows users to delete a character.

### Additional Notes

- Ensure that your AWS resources are properly secured and monitored.
- Regularly update your dependencies and AWS services to maintain security and performance.
- Consider implementing logging and monitoring for your Lambda functions using AWS CloudWatch.

### Conclusion

The Rick & Morty App is a fun and engaging project that showcases the capabilities of Flutter and AWS. By following the setup instructions and utilizing the provided AWS services, you can successfully run and deploy the application.
