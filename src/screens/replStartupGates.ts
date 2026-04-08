/**
 * Startup gates for the REPL.
 *
 * Prevents startup plugin checks and recommendation dialogs from stealing
 * focus before the user has interacted with the prompt.
 *
 * This addresses the root cause of issue #363: on mount, performStartupChecks
 * triggers plugin loading, which populates trackedFiles, which triggers
 * useLspPluginRecommendation to surface an LSP recommendation dialog. Since
 * promptTypingSuppressionActive is false before the user has typed anything,
 * getFocusedInputDialog() returns the dialog, unmounting PromptInput entirely.
 *
 * The fix gates startup checks on actual prompt readiness — either the user
 * has started typing (inputValue is non-empty) or has submitted their first
 * message. A pure timeout is insufficient because pausing for >1.5s before
 * typing would still allow dialogs to steal focus.
 */

const STARTUP_GRACE_PERIOD_MS = 3000

/**
 * Determines whether startup checks should run.
 *
 * Startup checks are deferred until one of:
 * 1. The user has typed something into the prompt (inputValue non-empty)
 * 2. The user has submitted their first message (hasHadFirstSubmission)
 * 3. The grace period has elapsed AND the user is not actively typing
 *    (fallback for long idle periods where checks should eventually run,
 *    but only when it won't interrupt an active typing session)
 */
export function shouldRunStartupChecks(options: {
  isRemoteSession: boolean;
  hasStarted: boolean;
  promptTypingSuppressionActive: boolean;
  hasHadFirstSubmission: boolean;
  gracePeriodElapsed: boolean;
}): boolean {
  if (options.isRemoteSession) return false;
  if (options.hasStarted) return false;

  // User has submitted their first message — safe to run checks
  if (options.hasHadFirstSubmission) return true;

  // User has typed something and grace period has passed — safe once they stop
  if (options.promptTypingSuppressionActive && options.gracePeriodElapsed) return false;

  // Grace period elapsed and user is idle — safe to run checks
  if (options.gracePeriodElapsed && !options.promptTypingSuppressionActive) return true;

  // Before grace period — don't run checks yet
  return false;
}

export { STARTUP_GRACE_PERIOD_MS }