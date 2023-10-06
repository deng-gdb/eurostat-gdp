from prefect.filesystems import GitHub
import setup

# alternative to creating GitHub block in the UI
gh_block = GitHub(
    name="eurostat-gdp-github", repository=setup.github_repository_url
)

gh_block.save("eurostat-gdp-github", overwrite=True)
