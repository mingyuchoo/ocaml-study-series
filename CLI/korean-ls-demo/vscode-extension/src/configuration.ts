import * as vscode from 'vscode';

/**
 * Configuration manager for Korean Language Server extension
 */
export class Configuration {
    private static readonly SECTION = 'koreanLanguageServer';

    /**
     * Get the path to the language server executable
     * @returns Server path from configuration or empty string
     */
    public static getServerPath(): string {
        const config = vscode.workspace.getConfiguration(this.SECTION);
        return config.get<string>('serverPath', '');
    }

    /**
     * Get the log level for the language server
     * @returns Log level (debug, info, warning, error)
     */
    public static getLogLevel(): string {
        const config = vscode.workspace.getConfiguration(this.SECTION);
        return config.get<string>('logLevel', 'info');
    }

    /**
     * Get the trace level for server communication
     * @returns Trace level (off, messages, verbose)
     */
    public static getTraceLevel(): string {
        const config = vscode.workspace.getConfiguration(this.SECTION);
        return config.get<string>('trace.server', 'off');
    }

    /**
     * Register a callback to be invoked when configuration changes
     * @param callback Function to call when configuration changes
     * @returns Disposable to unregister the listener
     */
    public static onConfigurationChanged(
        callback: (e: vscode.ConfigurationChangeEvent) => void
    ): vscode.Disposable {
        return vscode.workspace.onDidChangeConfiguration((e) => {
            if (e.affectsConfiguration(this.SECTION)) {
                callback(e);
            }
        });
    }

    /**
     * Check if a specific configuration key has changed
     * @param e Configuration change event
     * @param key Configuration key to check
     * @returns True if the key was changed
     */
    public static hasChanged(
        e: vscode.ConfigurationChangeEvent,
        key: string
    ): boolean {
        return e.affectsConfiguration(`${this.SECTION}.${key}`);
    }
}
