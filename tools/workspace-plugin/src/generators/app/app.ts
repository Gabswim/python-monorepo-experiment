import {
  addProjectConfiguration,
  formatFiles,
  generateFiles,
  Tree,
} from '@nx/devkit';
import * as path from 'path';
import { AppGeneratorSchema } from './schema';

export async function appGenerator(tree: Tree, options: AppGeneratorSchema) {
  const { name } = options;
  const moduleName = name.replace(/-/g, '_');
  const projectName = `postmodern-${name}`;
  const projectRoot = `apps/${name}`;

  addProjectConfiguration(tree, projectName, {
    root: projectRoot,
    projectType: 'application',
    sourceRoot: `${projectRoot}/postmodern/${moduleName}`,
    targets: {
      dev: {
        executor: 'nx:run-commands',
        options: {
          command: `uv run uvicorn postmodern.${moduleName}.run:app --reload --port 8000`,
          cwd: projectRoot,
        },
      },
      test: {
        executor: 'nx:run-commands',
        options: { command: 'uv run pytest .', cwd: projectRoot },
      },
      check: {
        executor: 'nx:run-commands',
        options: { command: 'uv run ty check .', cwd: projectRoot },
      },
      fmt: {
        executor: 'nx:run-commands',
        options: { command: 'uv run ruff format .', cwd: projectRoot },
      },
      lint: {
        executor: 'nx:run-commands',
        options: {
          command: 'uv run ruff check --fix .',
          cwd: projectRoot,
        },
      },
      'ci:fmt': {
        executor: 'nx:run-commands',
        options: {
          command: 'uv run ruff format --check .',
          cwd: projectRoot,
        },
      },
      'ci:lint': {
        executor: 'nx:run-commands',
        options: { command: 'uv run ruff check .', cwd: projectRoot },
      },
      'docker:build': {
        executor: 'nx:run-commands',
        options: {
          command: `docker build -f ${projectRoot}/Dockerfile -t ghcr.io/$(echo \${GITHUB_REPOSITORY_OWNER:-local} | tr '[:upper:]' '[:lower:]')/${projectName}:\${TAG:-latest} .`,
        },
      },
      'docker:push': {
        executor: 'nx:run-commands',
        options: {
          command: `docker push ghcr.io/$(echo \${GITHUB_REPOSITORY_OWNER:-local} | tr '[:upper:]' '[:lower:]')/${projectName}:\${TAG:-latest}`,
        },
      },
    },
  });

  generateFiles(tree, path.join(__dirname, 'files'), projectRoot, {
    name,
    moduleName,
    projectName,
    tmpl: '',
  });

  await formatFiles(tree);
}

export default appGenerator;
