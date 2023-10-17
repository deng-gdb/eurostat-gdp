from prefect.filesystems import GitHub
import proj_setup

# alternative to creating GitHub block in the UI
gh_block = GitHub(
    name="eurostat-gdp-github", repository=proj_setup.github_repository_url
)

gh_block.get_directory("flows") # specify a subfolder of repo where your flows code is located

gh_block.save("eurostat-gdp-github", overwrite=True)
