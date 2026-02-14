import React from 'react';
import { Box, Text, useInput } from 'ink';

export default function CardList({
  cards,
  selectedIndex,
  onSelect,
  onSearch,
  onNextPage,
  onPrevPage,
  onQuit,
  onRefresh,
  onNavigate,
  offset,
  totalCount,
  pageSize
}) {
  useInput((input, key) => {
    if (input === 'q') {
      onQuit();
    } else if (input === 'r') {
      onRefresh();
    } else if (input === 'j' || key.downArrow) {
      onNavigate('down');
    } else if (input === 'k' || key.upArrow) {
      onNavigate('up');
    } else if (input === 'n' || key.rightArrow) {
      onNextPage();
    } else if (input === 'p' || key.leftArrow) {
      onPrevPage();
    } else if (input === '/') {
      onSearch();
    } else if (key.return) {
      if (cards[selectedIndex]) {
        onSelect(cards[selectedIndex]);
      }
    }
  });

  const currentPage = Math.floor(offset / pageSize) + 1;
  const totalPages = Math.ceil(totalCount / pageSize);

  return (
    <Box flexDirection="column">
      <Box marginBottom={1}>
        <Text>
          Page {currentPage} of {totalPages} ({offset + 1}-{Math.min(offset + pageSize, totalCount)} of {totalCount})
        </Text>
      </Box>

      <Box flexDirection="column" marginBottom={1}>
        {cards.map((card, index) => {
          const displayTitle = card.reference_level
            ? `${card.title} (${card.reference_level_label || card.reference_level})`
            : card.title;

          const reviewIndicator = card.needs_review ? ' ⚠️ ' : '';

          return (
            <Box key={card.id}>
              <Text color={index === selectedIndex ? 'cyan' : 'white'}>
                {index === selectedIndex ? '> ' : '  '}
                {card.card_number} - {displayTitle}{reviewIndicator}
              </Text>
            </Box>
          );
        })}
      </Box>

      <Box borderStyle="single" borderColor="gray" paddingX={1}>
        <Text dimColor>
          j/k or ↑/↓: Navigate | Enter: View | /: Search | n/p or ←/→: Next/Prev Page | r: Refresh | q: Quit
        </Text>
      </Box>
    </Box>
  );
}

