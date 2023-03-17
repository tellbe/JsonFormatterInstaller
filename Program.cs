// Get files from repo

// If connection to Github repo is ok - check PowerShell for Modules path $env:PSModulePath
// If %user%\Documents\WindowsPowerShell\Modules exits in ModulePath, continue. Otherwise add path to Powershell module paths
// if file exits, check if directory exits %user%\Documents\WindowsPowerShell\Modules

// if files exits, copy to $user\Documents\WindowsPowerShell

// exit


using Octokit;
using System.Collections;

var github = new GitHubClient(new ProductHeaderValue("JsonFormatterInstaller"));
var repositoryOwner = "tellbe";
var repositoryName = "repository-name";
var filePathsToCheck = new List<string> { "path/to/file1.txt", "path/to/file2.txt" };

// Get the repository information
var repository = github.Repository.Get(repositoryOwner, repositoryName).Result;

foreach (var filePath in filePathsToCheck)
{
    // Check if the file exists in the repository
    var fileExists = github.Repository.Content.GetAllContentsByRef(repositoryOwner, repositoryName, filePath, repository.DefaultBranch).Result.Count > 0;

    if (fileExists)
    {
        Console.WriteLine($"File {filePath} exists in the repository");
        // Prepare the file for download
        var fileContent = github.Repository.Content.GetRawContentByRef(repositoryOwner, repositoryName, filePath, repository.DefaultBranch).Result;
        var localFilePath = Path.Combine(Directory.GetCurrentDirectory(), filePath);
        Directory.CreateDirectory(Path.GetDirectoryName(localFilePath) ?? string.Empty);
        var result = System.Text.Encoding.UTF8.GetString(fileContent);
        File.WriteAllText(localFilePath, result);
    }
    else
    {
        Console.WriteLine($"File {filePath} does not exist in the repository");
    }
}