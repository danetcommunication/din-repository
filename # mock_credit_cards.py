# mock_credit_cards.py

# Example of mock credit card data for testing only
# These numbers follow card formats but are NOT real and cannot be used.

mock_cards = [
    {
        "card_holder": "John Doe",
        "card_number": "4111 1111 1111 1111",  # Visa test number
        "expiry": "12/28",
        "cvv": "123"
    },
    {
        "card_holder": "Jane Smith",
        "card_number": "5500 0000 0000 0004",  # MasterCard test number
        "expiry": "05/27",
        "cvv": "456"
    },
    {
        "card_holder": "Alice Johnson",
        "card_number": "3782 822463 10005",  # American Express test number
        "expiry": "09/29",
        "cvv": "789"
    }
]

def print_cards():
    print("Mock Credit Card List:\n")
    for card in mock_cards:
        print(f"Holder: {card['card_holder']}")
        print(f"Number: {card['card_number']}")
        print(f"Expiry: {card['expiry']}")
        print(f"CVV: {card['cvv']}")
        print("-" * 30)


if __name__ == "__main__":
    print_cards()
