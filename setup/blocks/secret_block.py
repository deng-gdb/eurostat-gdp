from prefect.blocks.system import Secret
import proj_setup

# create Prefect Secret block with the name "project-id"
Secret(value=proj_setup.project_id).save(name="project-id")