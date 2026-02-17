import React, { useState } from 'react';
import { Box, Text, useInput } from 'ink';
import TextInput from 'ink-text-input';

export default function JumpToCardInput({ onSubmit, onCancel }) {
  const [cardNumber, setCardNumber] = useState('');

  // Handle Esc key explicitly to return to card list
  useInput((input, key) => {
    if (key.escape) {
      onCancel();
    }
  });

  const handleSubmit = () => {
    if (cardNumber.trim()) {
      onSubmit(cardNumber.trim());
    } else {
      onCancel();
    }
  };

  return (
    <Box flexDirection="column">
      <Box marginBottom={1}>
        <Text bold color="yellow">Jump to Card</Text>
      </Box>

      <Box marginBottom={1}>
        <Text>Enter card number (e.g., 1924 for C01924): </Text>
        <TextInput
          value={cardNumber}
          onChange={setCardNumber}
          onSubmit={handleSubmit}
        />
      </Box>

      <Box borderStyle="single" borderColor="gray" paddingX={1}>
        <Text dimColor>
          Enter: Jump to card | Esc: Back to card list
        </Text>
      </Box>
    </Box>
  );
}

