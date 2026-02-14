import React from 'react';
import { Box, Text, useInput } from 'ink';

export default function CardDetail({ card, onBack, onQuit }) {
  useInput((input, key) => {
    if (input === 'q') {
      onQuit();
    } else if (input === 'b' || key.leftArrow) {
      onBack();
    }
  });

  const truncate = (text, maxLength) => {
    if (!text) return '';
    if (text.length <= maxLength) return text;
    return text.slice(0, maxLength - 3) + '...';
  };

  const displayTitle = (card.reference_level || card.reference_level_label)
    ? `${card.title} (${card.reference_level_label || card.reference_level})`
    : card.title;

  return (
    <Box flexDirection="column">
      <Box marginBottom={1}>
        <Text bold color="cyan">
          {card.card_number} - {displayTitle}
        </Text>
      </Box>

      {card.needs_review === 1 && (
        <Box marginBottom={1} borderStyle="single" borderColor="yellow" padding={1}>
          <Text bold color="yellow">
            ⚠️  NEEDS REVIEW: {card.review_notes || 'This card needs manual review'}
          </Text>
        </Box>
      )}

      <Box flexDirection="column" marginBottom={1} borderStyle="single" borderColor="gray" padding={1}>
        <Box marginBottom={1}>
          <Text bold color="yellow">Content:</Text>
        </Box>
        <Box>
          <Text>{card.content_text || '(no content)'}</Text>
        </Box>

        {card.see_links && (
          <Box marginTop={1}>
            <Text bold color="yellow">See Also: </Text>
            <Text>{card.see_links}</Text>
          </Box>
        )}

        {card.text_citations && (
          <Box marginTop={1}>
            <Text bold color="yellow">Text Citations: </Text>
            <Text>{card.text_citations}</Text>
          </Box>
        )}

        {card.image_path && (
          <Box marginTop={1}>
            <Text bold color="yellow">Image: </Text>
            <Text dimColor>{card.image_path}</Text>
          </Box>
        )}
      </Box>

      <Box borderStyle="single" borderColor="gray" paddingX={1}>
        <Text dimColor>
          b or ←: Back | q: Quit
        </Text>
      </Box>
    </Box>
  );
}

