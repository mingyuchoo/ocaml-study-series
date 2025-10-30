import * as vscode from 'vscode';
import {
    LanguageClient,
    LanguageClientOptions,
    ServerOptions,
    TransportKind,
    Trace
} from 'vscode-languageclient/node';
import { Configuration } from './configuration';

/**
 * Korean Language Client manager
 */
export class KoreanLanguageClient {
    private client: LanguageClient | undefined;
    private context: vscode.ExtensionContext;
    private outputChannel: vscode.OutputChannel;
    private restartCount: number = 0;
    private readonly MAX_RESTART_COUNT = 5;

    constructor(context: vscode.ExtensionContext, outputChannel: vscode.OutputChannel) {
        this.context = context;
        this.outputChannel = outputChannel;
    }

    /**
     * Start the language server
     */
    public async start(): Promise<void> {
        if (this.client) {
            this.outputChannel.appendLine('Language server is already running');
            return;
        }

        try {
            const serverPath = this.getServerPath();
            this.outputChannel.appendLine(`Starting Korean Language Server: ${serverPath}`);

            const serverOptions: ServerOptions = {
                command: serverPath,
                args: [],
                transport: TransportKind.stdio
            };

            const clientOptions: LanguageClientOptions = {
                documentSelector: [{ scheme: 'file', language: 'korean' }],
                synchronize: {
                    fileEvents: vscode.workspace.createFileSystemWatcher('**/*.kr')
                },
                outputChannel: this.outputChannel,
                traceOutputChannel: this.outputChannel,
                revealOutputChannelOn: this.getRevealOutputChannelOn()
            };

            this.client = new LanguageClient(
                'koreanLanguageServer',
                'Korean Language Server',
                serverOptions,
                clientOptions
            );

            // Set trace level
            const traceLevel = Configuration.getTraceLevel();
            this.client.setTrace(this.convertTraceLevel(traceLevel));

            // Handle server crashes
            this.client.onDidChangeState((event) => {
                if (event.newState === 3) { // State.Stopped
                    this.handleServerCrash();
                }
            });

            await this.client.start();
            this.outputChannel.appendLine('Korean Language Server started successfully');
            this.restartCount = 0;
        } catch (error) {
            const errorMessage = error instanceof Error ? error.message : String(error);
            this.outputChannel.appendLine(`Failed to start language server: ${errorMessage}`);
            vscode.window.showErrorMessage(
                `Failed to start Korean Language Server: ${errorMessage}. ` +
                `Please check the server path in settings.`
            );
            throw error;
        }
    }

    /**
     * Stop the language server
     */
    public async stop(): Promise<void> {
        if (!this.client) {
            return;
        }

        try {
            this.outputChannel.appendLine('Stopping Korean Language Server...');
            await this.client.stop();
            this.client = undefined;
            this.outputChannel.appendLine('Korean Language Server stopped');
        } catch (error) {
            const errorMessage = error instanceof Error ? error.message : String(error);
            this.outputChannel.appendLine(`Error stopping language server: ${errorMessage}`);
        }
    }

    /**
     * Restart the language server
     */
    public async restart(): Promise<void> {
        this.outputChannel.appendLine('Restarting Korean Language Server...');
        await this.stop();
        await this.start();
    }

    /**
     * Check if the client is running
     */
    public isRunning(): boolean {
        return this.client !== undefined;
    }

    /**
     * Get the server executable path
     */
    private getServerPath(): string {
        let serverPath = Configuration.getServerPath();

        if (!serverPath) {
            // Try to find the server in the workspace
            const workspaceFolders = vscode.workspace.workspaceFolders;
            if (workspaceFolders && workspaceFolders.length > 0) {
                const workspaceRoot = workspaceFolders[0].uri.fsPath;
                serverPath = `${workspaceRoot}/_build/default/bin/main.exe`;
            } else {
                throw new Error(
                    'Server path not configured. Please set koreanLanguageServer.serverPath in settings.'
                );
            }
        }

        return serverPath;
    }

    /**
     * Handle server crash and attempt restart
     */
    private async handleServerCrash(): Promise<void> {
        if (this.restartCount >= this.MAX_RESTART_COUNT) {
            this.outputChannel.appendLine(
                `Language server crashed ${this.MAX_RESTART_COUNT} times. Not restarting.`
            );
            vscode.window.showErrorMessage(
                'Korean Language Server has crashed multiple times. Please check the logs and restart manually.',
                'Open Logs'
            ).then((selection) => {
                if (selection === 'Open Logs') {
                    this.outputChannel.show();
                }
            });
            return;
        }

        this.restartCount++;
        this.outputChannel.appendLine(
            `Language server crashed. Attempting restart (${this.restartCount}/${this.MAX_RESTART_COUNT})...`
        );

        const selection = await vscode.window.showWarningMessage(
            'Korean Language Server has stopped unexpectedly. Restart?',
            'Restart',
            'Cancel'
        );

        if (selection === 'Restart') {
            try {
                await this.restart();
            } catch (error) {
                const errorMessage = error instanceof Error ? error.message : String(error);
                this.outputChannel.appendLine(`Failed to restart: ${errorMessage}`);
            }
        }
    }

    /**
     * Convert trace level string to Trace enum
     */
    private convertTraceLevel(level: string): Trace {
        switch (level) {
            case 'messages':
                return Trace.Messages;
            case 'verbose':
                return Trace.Verbose;
            default:
                return Trace.Off;
        }
    }

    /**
     * Get the reveal output channel setting based on log level
     */
    private getRevealOutputChannelOn(): number {
        const logLevel = Configuration.getLogLevel();
        // RevealOutputChannelOn: Never = 1, Info = 2, Warn = 3, Error = 4
        switch (logLevel) {
            case 'debug':
                return 2; // Info
            case 'info':
                return 3; // Warn
            case 'warning':
                return 3; // Warn
            case 'error':
                return 4; // Error
            default:
                return 3; // Warn
        }
    }
}
