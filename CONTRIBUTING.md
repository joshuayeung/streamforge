# **Contribution Guidelines**

Thank you for your interest in contributing to **StreamForge**! Contributions are welcome and encouraged, as they help improve the project and benefit the wider community. Please take a moment to review these guidelines before making your contribution.

## **How to Contribute**

1. **Fork the Repository**:  
   Begin by forking the repository to your own GitHub account. This will create your own copy of the project.

2. **Create a Branch**:  
   Create a new branch for your changes. We follow the feature-branch workflow, so it’s best to keep changes isolated in individual branches.
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**:  
   Implement your changes or features in the new branch. Make sure your code adheres to the project’s coding standards and follows the structure of the project.

4. **Test Your Changes**:  
   Ensure your changes work as expected and don’t break any existing functionality. If possible, add unit or integration tests to cover your updates.

5. **Commit Your Changes**:  
   Write a clear and descriptive commit message for each change:
   ```bash
   git commit -m "Add detailed description of your feature/fix"
   ```

6. **Push to Your Fork**:  
   Push your branch to your forked repository:
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Submit a Pull Request (PR)**:  
   Open a pull request to the original repository, explaining the purpose and details of your contribution. Ensure your PR adheres to the following guidelines:
   - Clearly describe the problem your contribution addresses or the feature it implements.
   - Reference related issues (if any).
   - If it’s a large change, consider breaking it down into smaller PRs for easier review.
   - Include screenshots or logs if relevant to your change.
   
   We’ll review your PR as soon as possible. Be prepared to make revisions based on feedback from maintainers.

## **Code of Conduct**

All contributors are expected to adhere to our [Code of Conduct](CODE_OF_CONDUCT.md). Please ensure you are respectful and considerate in your interactions.

## **Style Guide**

Please follow these coding conventions:
- **Language**: We use **Python** for Airflow DAGs, Kafka producers/consumers, and any other core logic.
- **Formatting**: Use **PEP 8** for Python code.
- **Comments**: Write meaningful comments where necessary to explain complex logic.
- **Commit Messages**: Use clear and concise commit messages that accurately describe the changes made.

## **Reporting Issues**

If you encounter a bug or have a feature request, feel free to open an issue. Please include as much detail as possible, including steps to reproduce the issue if it’s a bug, or a clear explanation of the feature you are requesting.

## **License**

By contributing to this project, you agree that your contributions will be licensed under the same license as this project (with commercial use requiring approval as outlined in the [LICENSE](LICENSE)).
