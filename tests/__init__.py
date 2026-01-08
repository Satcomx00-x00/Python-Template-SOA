"""
Test Suite Configuration

This file is automatically discovered by pytest.
It can contain fixtures and configuration that apply to all tests.
"""

import pytest


@pytest.fixture
def sample_data():
    """
    Fixture providing sample data for tests.

    Fixtures are functions that run before tests and provide data/setup.
    They can be reused across multiple tests.

    Returns:
        dict: Sample data for testing
    """
    return {
        "names": ["Alice", "Bob", "Charlie"],
        "numbers": [1, 2, 3, 4, 5],
        "config": {"version": "1.0", "debug": False},
    }


@pytest.fixture
def sample_numbers():
    """
    Fixture providing sample numbers for mathematical tests.

    Returns:
        tuple: A tuple of (x, y) for testing calculations
    """
    return (10, 5)
