import { describe, expect, test } from 'bun:test'

import { shouldRunStartupChecks, STARTUP_GRACE_PERIOD_MS } from './replStartupGates.js'

describe('shouldRunStartupChecks', () => {
  test('runs checks after first message submission regardless of grace period', () => {
    expect(shouldRunStartupChecks({
      isRemoteSession: false,
      hasStarted: false,
      promptTypingSuppressionActive: false,
      hasHadFirstSubmission: true,
      gracePeriodElapsed: false,
    })).toBe(true)
  })

  test('skips checks in remote sessions', () => {
    expect(shouldRunStartupChecks({
      isRemoteSession: true,
      hasStarted: false,
      promptTypingSuppressionActive: false,
      hasHadFirstSubmission: false,
      gracePeriodElapsed: true,
    })).toBe(false)
  })

  test('skips checks if already started', () => {
    expect(shouldRunStartupChecks({
      isRemoteSession: false,
      hasStarted: true,
      promptTypingSuppressionActive: false,
      hasHadFirstSubmission: false,
      gracePeriodElapsed: true,
    })).toBe(false)
  })

  test('does not run checks before grace period when user is idle', () => {
    expect(shouldRunStartupChecks({
      isRemoteSession: false,
      hasStarted: false,
      promptTypingSuppressionActive: false,
      hasHadFirstSubmission: false,
      gracePeriodElapsed: false,
    })).toBe(false)
  })

  test('runs checks after grace period when user is idle', () => {
    expect(shouldRunStartupChecks({
      isRemoteSession: false,
      hasStarted: false,
      promptTypingSuppressionActive: false,
      hasHadFirstSubmission: false,
      gracePeriodElapsed: true,
    })).toBe(true)
  })

  test('does not run checks while user is actively typing even after grace period', () => {
    expect(shouldRunStartupChecks({
      isRemoteSession: false,
      hasStarted: false,
      promptTypingSuppressionActive: true,
      hasHadFirstSubmission: false,
      gracePeriodElapsed: true,
    })).toBe(false)
  })

  test('runs checks after first submission even while typing', () => {
    expect(shouldRunStartupChecks({
      isRemoteSession: false,
      hasStarted: false,
      promptTypingSuppressionActive: true,
      hasHadFirstSubmission: true,
      gracePeriodElapsed: false,
    })).toBe(true)
  })

  test('does not run checks before grace period even with typing suppression', () => {
    expect(shouldRunStartupChecks({
      isRemoteSession: false,
      hasStarted: false,
      promptTypingSuppressionActive: true,
      hasHadFirstSubmission: false,
      gracePeriodElapsed: false,
    })).toBe(false)
  })
})

describe('STARTUP_GRACE_PERIOD_MS', () => {
  test('grace period is positive and reasonable', () => {
    expect(STARTUP_GRACE_PERIOD_MS).toBeGreaterThan(0)
    expect(STARTUP_GRACE_PERIOD_MS).toBeLessThanOrEqual(10000)
  })
})