<?php

declare(strict_types=1);

namespace Tests\Integration;

use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

final class ExampleCommandTest extends TestCase
{
    private string $scriptPath;

    protected function setUp(): void
    {
        $this->scriptPath = dirname(__DIR__, 2) . '/bin/example';
    }

    public function testDefaultExecutionOutputsHelloWorld(): void
    {
        $result = $this->runCommand();

        $this->assertSame(0, $result['exitCode']);
        $this->assertSame("Hello World\n", $result['output']);
    }

    public function testHelpOptionOutputsUsageInformation(): void
    {
        $result = $this->runCommand('--help');

        $this->assertSame(0, $result['exitCode']);
        $this->assertStringContainsString('Usage:', $result['output']);
        $this->assertStringContainsString('bin/example [options]', $result['output']);
        $this->assertStringContainsString('-i, --info', $result['output']);
        $this->assertStringContainsString('--version', $result['output']);
        $this->assertStringContainsString('--help', $result['output']);
    }

    public function testVersionOptionOutputsPhpVersion(): void
    {
        $result = $this->runCommand('--version');

        $this->assertSame(0, $result['exitCode']);
        $this->assertStringStartsWith('PHP ' . PHP_VERSION, trim($result['output']));
    }

    #[DataProvider('infoOptionProvider')]
    public function testInfoOptionOutputsPhpInfo(string $option): void
    {
        $result = $this->runCommand($option);

        $this->assertSame(0, $result['exitCode']);
        $this->assertStringContainsString('phpinfo()', $result['output']);
    }

    /**
     * @return array<string, array{0: string}>
     */
    public static function infoOptionProvider(): array
    {
        return [
            'short option' => ['-i'],
            'long option' => ['--info'],
        ];
    }

    /**
     * @return array{output: string, error: string, exitCode: int}
     */
    private function runCommand(string $arguments = ''): array
    {
        $command = sprintf('%s %s %s', escapeshellcmd(PHP_BINARY), escapeshellarg($this->scriptPath), $arguments);

        $descriptors = [
            0 => ['pipe', 'r'],
            1 => ['pipe', 'w'],
            2 => ['pipe', 'w'],
        ];

        $process = proc_open($command, $descriptors, $pipes);
        if (!is_resource($process)) {
            $this->fail('Failed to execute command: ' . $command);
        }

        fclose($pipes[0]);
        $stdout = stream_get_contents($pipes[1]);
        fclose($pipes[1]);
        $stderr = stream_get_contents($pipes[2]);
        fclose($pipes[2]);

        $exitCode = proc_close($process);

        return [
            'output' => $stdout !== false ? $stdout : '',
            'error' => $stderr !== false ? $stderr : '',
            'exitCode' => $exitCode,
        ];
    }
}
