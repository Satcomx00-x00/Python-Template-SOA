"""
Main Module

A simple Python program demonstrating best practices.
"""


def add(a: float, b: float) -> float:
    """
    Add two numbers together.

    Args:
        a: First number
        b: Second number

    Returns:
        Sum of a and b

    Example:
        >>> add(2, 3)
        5.0
    """
    return a + b


def greet(name: str) -> str:
    """
    Generate a greeting message.

    Args:
        name: Name to greet

    Returns:
        Greeting message

    Example:
        >>> greet("World")
        'Hello, World!'
    """
    return f"Hello, {name}!"


def main() -> None:
    """Main entry point of the program."""
    # Simple greeting
    message = greet("Python Developer")
    print(message)

    # Simple calculation
    result = add(10, 5)
    print(f"10 + 5 = {result}")


# Entry point when running as script: python -m python_template.main
if __name__ == "__main__":
    main()
