"""
Tests for Main Module

This module tests the functionality in python_template.main
Demonstrates pytest best practices and various testing patterns.
"""

import pytest

from python_template.main import add, greet


# ============================================================================
# Tests for greet() function
# ============================================================================


class TestGreet:
    """Test suite for the greet() function."""

    def test_greet_basic(self):
        """Test basic greeting functionality."""
        result = greet("Alice")
        expected = "Hello, Alice!"
        assert result == expected

    def test_greet_world(self):
        """Test greeting with 'World'."""
        result = greet("World")
        assert result == "Hello, World!"

    @pytest.mark.parametrize(
        "name,expected",
        [
            ("Alice", "Hello, Alice!"),
            ("Bob", "Hello, Bob!"),
            ("Python", "Hello, Python!"),
        ],
    )
    def test_greet_parametrized(self, name: str, expected: str):
        """
        Test greet() with multiple inputs using parametrize.

        Parametrize runs the same test with different inputs.
        """
        assert greet(name) == expected


# ============================================================================
# Tests for add() function
# ============================================================================


class TestAdd:
    """Test suite for the add() function."""

    def test_add_positive_numbers(self):
        """Test addition of positive numbers."""
        result = add(10, 5)
        assert result == 15.0

    def test_add_negative_numbers(self):
        """Test addition of negative numbers."""
        result = add(-5, -3)
        assert result == -8.0

    def test_add_mixed_numbers(self):
        """Test addition of positive and negative numbers."""
        result = add(10, -5)
        assert result == 5.0

    def test_add_with_zero(self):
        """Test addition with zero."""
        assert add(0, 0) == 0.0
        assert add(5, 0) == 5.0
        assert add(0, 5) == 5.0

    def test_add_floats(self):
        """Test addition with floating point numbers."""
        result = add(10.5, 2.5)
        assert result == pytest.approx(13.0)

    @pytest.mark.parametrize(
        "a,b,expected",
        [
            (2, 3, 5.0),
            (0, 0, 0.0),
            (-5, 3, -2.0),
            (10.5, 2.5, 13.0),
            (100, 200, 300.0),
        ],
    )
    def test_add_parametrized(self, a: float, b: float, expected: float):
        """Test add() with multiple scenarios."""
        result = add(a, b)
        assert result == pytest.approx(expected)


# ============================================================================
# Integration Tests
# ============================================================================


class TestIntegration:
    """Integration tests that test multiple components together."""

    def test_greet_and_add_together(self):
        """Test that both functions work correctly when used together."""
        # Test greeting
        greeting = greet("Alice")
        assert "Alice" in greeting

        # Test addition
        sum_result = add(10, 5)
        assert sum_result == 15.0

        # Both functions executed successfully
