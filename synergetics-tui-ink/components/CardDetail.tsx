import React from 'react';
import { Box, Text, useInput } from 'ink';

export default function CardDetail({ card, onBack, onQuit, onNavigateToCard }) {
  const seeLinks = Array.isArray(card.see_links) ? card.see_links : [];
  const navigableLinks = seeLinks.filter(link => link.target_card_id);

  useInput((input, key) => {
    if (input === 'q') {
      onQuit();
    } else if (input === 'b' || input === 'a' || key.leftArrow || key.escape) {
      onBack();
    } else if (onNavigateToCard && navigableLinks.length > 0) {
      const num = parseInt(input, 10);
      if (num >= 1 && num <= 9 && num <= navigableLinks.length) {
        const link = navigableLinks[num - 1];
        if (link?.target_card_id) {
          onNavigateToCard(link.target_card_id);
        }
      }
    }
  });

  const stripLatexHyperref = (text) => {
    if (!text || typeof text !== 'string') return '';
    const m = text.match(/\\hyperref\[[^\]]*\]\{([^{}]*)\}/);
    return m ? m[1] : text;
  };

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

        {seeLinks.length > 0 && (
          <Box marginTop={1} flexDirection="column">
            <Box marginBottom={1}>
              <Text bold color="yellow">See Also: </Text>
              {navigableLinks.length > 0 && (
                <Text dimColor> (1-{Math.min(9, navigableLinks.length)}: go to card)</Text>
              )}
            </Box>
            <Box flexDirection="column">
              {seeLinks.map((link, idx) => {
                const num = navigableLinks.indexOf(link) + 1;
                const isNavigable = num > 0 && num <= 9;
                const raw = link.display_text || link.line_content || '';
                const label = stripLatexHyperref(raw) || raw || '?';
                return (
                  <Box key={`see-${idx}`}>
                    {isNavigable ? (
                      <Text color="cyan" bold>{num}. </Text>
                    ) : (
                      <Text dimColor>  </Text>
                    )}
                    <Text color={isNavigable ? 'cyan' : undefined}>{label}</Text>
                    {!link.target_card_id && (
                      <Text dimColor> (unresolved)</Text>
                    )}
                  </Box>
                );
              })}
            </Box>
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
          Esc/a/b/←: Back to list
          {navigableLinks.length > 0 && ` | 1-${Math.min(9, navigableLinks.length)}: Go to See link`}
          {' | q: Quit'}
        </Text>
      </Box>
    </Box>
  );
}

