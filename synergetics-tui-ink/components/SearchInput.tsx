import React, { useState } from 'react';
import { Box, Text } from 'ink';
import TextInput from 'ink-text-input';

export default function SearchInput({ onSubmit, onCancel }) {
  const [query, setQuery] = useState('');

  const handleSubmit = () => {
    if (query.trim()) {
      onSubmit(query.trim());
    } else {
      onCancel();
    }
  };

  return (
    <Box flexDirection="column">
      <Box marginBottom={1}>
        <Text bold color="yellow">Search Cards</Text>
      </Box>

      <Box marginBottom={1}>
        <Text>Enter search query: </Text>
        <TextInput
          value={query}
          onChange={setQuery}
          onSubmit={handleSubmit}
        />
      </Box>

      <Box borderStyle="single" borderColor="gray" paddingX={1}>
        <Text dimColor>
          Enter: Search | Esc: Cancel
        </Text>
      </Box>
    </Box>
  );
}

