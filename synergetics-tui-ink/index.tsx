#!/usr/bin/env tsx
import React, { useState, useEffect } from 'react';
import { render, Box, Text } from 'ink';
import { countCards, listCards, getCard, getCardByNumber, closeDatabase } from './database.js';
import CardList from './components/CardList.tsx';
import CardDetail from './components/CardDetail.tsx';
import SearchInput from './components/SearchInput.tsx';
import JumpToCardInput from './components/JumpToCardInput.tsx';

function App() {
  const [mode, setMode] = useState('list'); // 'list', 'detail', 'search', 'jump'
  const [cards, setCards] = useState([]);
  const [selectedIndex, setSelectedIndex] = useState(0);
  const [currentCard, setCurrentCard] = useState(null);
  const [offset, setOffset] = useState(0);
  const [totalCount, setTotalCount] = useState(0);
  const [searchQuery, setSearchQuery] = useState('');
  const [message, setMessage] = useState('');

  const PAGE_SIZE = 20;

  const loadCards = (search = null, newOffset = 0) => {
    const cardList = listCards({
      limit: PAGE_SIZE,
      offset: newOffset,
      search
    });
    setCards(cardList);
    setOffset(newOffset);
    setSelectedIndex(0);
  };

  // Load initial data
  useEffect(() => {
    const total = countCards();
    setTotalCount(total);
    loadCards();
    setMessage(`Synergetics Dictionary - ${total} cards loaded`);
  }, []);

  const handleSelectCard = (card) => {
    const fullCard = getCard(card.id);
    setCurrentCard(fullCard);
    setMode('detail');
  };

  const handleBack = () => {
    setMode('list');
    setCurrentCard(null);
  };

  const handleSearch = () => {
    setMode('search');
  };

  const handleSearchSubmit = (query) => {
    setSearchQuery(query);
    loadCards(query, 0);
    setMode('list');
    setMessage(`Search results for: ${query}`);
  };

  const handleSearchCancel = () => {
    setMode('list');
    setMessage('Returned to card list');
  };

  const handleNextPage = () => {
    const newOffset = offset + PAGE_SIZE;
    if (newOffset < totalCount) {
      loadCards(searchQuery || null, newOffset);
      setMessage(`Page ${Math.floor(newOffset / PAGE_SIZE) + 1}`);
    }
  };

  const handlePrevPage = () => {
    const newOffset = Math.max(0, offset - PAGE_SIZE);
    loadCards(searchQuery || null, newOffset);
    setMessage(`Page ${Math.floor(newOffset / PAGE_SIZE) + 1}`);
  };

  const handleQuit = () => {
    closeDatabase();
    process.exit(0);
  };

  const handleRefresh = () => {
    const total = countCards();
    setTotalCount(total);
    loadCards(searchQuery || null, offset);
    setMessage(`Refreshed - ${total} cards loaded`);
  };

  const handleClearSearch = () => {
    setSearchQuery('');
    loadCards(null, 0);
    setMessage('Returned to full card list');
  };

  const handleJump = () => {
    setMode('jump');
  };

  const handleJumpSubmit = (cardNumber) => {
    const card = getCardByNumber(cardNumber);
    if (card) {
      const fullCard = getCard(card.id);
      setCurrentCard(fullCard);
      setMode('detail');
      setMessage(`Jumped to card ${card.card_number}`);
    } else {
      setMode('list');
      setMessage(`Card not found: ${cardNumber}`);
    }
  };

  const handleJumpCancel = () => {
    setMode('list');
    setMessage('Returned to card list');
  };

  const handleNavigateToCard = (cardId) => {
    const fullCard = getCard(cardId);
    if (fullCard) {
      setCurrentCard(fullCard);
      setMode('detail');
      setMessage(`Navigated to ${fullCard.card_number} - ${fullCard.title}`);
    }
  };

  return (
    <Box flexDirection="column" padding={1}>
      <Box borderStyle="round" borderColor="cyan" paddingX={1} marginBottom={1}>
        <Text bold color="cyan">Synergetics Dictionary TUI</Text>
      </Box>

      {message && (
        <Box marginBottom={1}>
          <Text color="yellow">{message}</Text>
        </Box>
      )}

      {mode === 'list' && (
        <CardList
          cards={cards}
          selectedIndex={selectedIndex}
          onSelect={handleSelectCard}
          onSearch={handleSearch}
          onJump={handleJump}
          onClearSearch={handleClearSearch}
          searchQuery={searchQuery}
          onNextPage={handleNextPage}
          onPrevPage={handlePrevPage}
          onQuit={handleQuit}
          onRefresh={handleRefresh}
          onNavigate={(direction) => {
            if (direction === 'down') {
              setSelectedIndex(Math.min(selectedIndex + 1, cards.length - 1));
            } else if (direction === 'up') {
              setSelectedIndex(Math.max(selectedIndex - 1, 0));
            }
          }}
          offset={offset}
          totalCount={totalCount}
          pageSize={PAGE_SIZE}
        />
      )}

      {mode === 'detail' && currentCard && (
        <CardDetail
          card={currentCard}
          onBack={handleBack}
          onQuit={handleQuit}
          onNavigateToCard={handleNavigateToCard}
        />
      )}

      {mode === 'search' && (
        <SearchInput
          onSubmit={handleSearchSubmit}
          onCancel={handleSearchCancel}
        />
      )}

      {mode === 'jump' && (
        <JumpToCardInput
          onSubmit={handleJumpSubmit}
          onCancel={handleJumpCancel}
        />
      )}
    </Box>
  );
}

render(<App />);

