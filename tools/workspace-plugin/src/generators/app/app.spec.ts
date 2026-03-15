import { createTreeWithEmptyWorkspace } from '@nx/devkit/testing';
import { Tree, readProjectConfiguration } from '@nx/devkit';

import { appGenerator } from './app';
import { AppGeneratorSchema } from './schema';

describe('app generator', () => {
  let tree: Tree;

  beforeEach(() => {
    tree = createTreeWithEmptyWorkspace();
  });

  it('should create project configuration', async () => {
    await appGenerator(tree, { name: 'my-app' });

    const config = readProjectConfiguration(tree, 'postmodern-my-app');
    expect(config.root).toBe('apps/my-app');
    expect(config.projectType).toBe('application');
    expect(config.sourceRoot).toBe('apps/my-app/postmodern/my_app');
  });

  it('should generate expected files', async () => {
    await appGenerator(tree, { name: 'my-app' });

    expect(tree.exists('apps/my-app/pyproject.toml')).toBe(true);
    expect(tree.exists('apps/my-app/README.md')).toBe(true);
    expect(tree.exists('apps/my-app/Dockerfile')).toBe(true);
    expect(tree.exists('apps/my-app/postmodern/my_app/__init__.py')).toBe(
      true
    );
    expect(tree.exists('apps/my-app/postmodern/my_app/py.typed')).toBe(true);
    expect(tree.exists('apps/my-app/postmodern/my_app/run.py')).toBe(true);
    expect(tree.exists('apps/my-app/tests/test_my_app.py')).toBe(true);
  });

  it('should set correct targets including dev and docker', async () => {
    await appGenerator(tree, { name: 'my-app' });

    const config = readProjectConfiguration(tree, 'postmodern-my-app');
    const targetNames = Object.keys(config.targets ?? {});
    expect(targetNames).toEqual(
      expect.arrayContaining([
        'dev',
        'test',
        'check',
        'fmt',
        'lint',
        'ci:fmt',
        'ci:lint',
        'docker:build',
        'docker:push',
      ])
    );
  });

  it('should set dev target with uvicorn command', async () => {
    await appGenerator(tree, { name: 'my-app' });

    const config = readProjectConfiguration(tree, 'postmodern-my-app');
    expect(config.targets?.['dev']?.options?.command).toContain(
      'uvicorn postmodern.my_app.run:app'
    );
  });

  it('should generate correct pyproject.toml content', async () => {
    await appGenerator(tree, { name: 'my-app' });

    const content = tree.read('apps/my-app/pyproject.toml', 'utf-8') ?? '';
    expect(content).toContain('name = "postmodern-my-app"');
    expect(content).toContain('module-name = "postmodern.my_app"');
    expect(content).toContain(
      'postmodern-my-app = "postmodern.my_app.run:main"'
    );
  });

  it('should generate correct Dockerfile content', async () => {
    await appGenerator(tree, { name: 'my-app' });

    const content = tree.read('apps/my-app/Dockerfile', 'utf-8') ?? '';
    expect(content).toContain('--package=postmodern-my-app');
    expect(content).toContain('CMD ["postmodern-my-app"]');
  });

  it('should handle names without hyphens', async () => {
    await appGenerator(tree, { name: 'api' });

    const config = readProjectConfiguration(tree, 'postmodern-api');
    expect(config.sourceRoot).toBe('apps/api/postmodern/api');
    expect(tree.exists('apps/api/postmodern/api/run.py')).toBe(true);
    expect(tree.exists('apps/api/tests/test_api.py')).toBe(true);
  });
});
