import React, { useState } from 'react';
import { Snowflake, ArrowUpRight } from 'lucide-react';
import Modal from './components/Modal';
import './App.css';

function App() {
  const [inputValue, setInputValue] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);
  const [modalContent, setModalContent] = useState('');
  const [error, setError] = useState<string | null>(null);

  const suggestedQuestions = [
    'Jay Peak, VT',
    'Les Deux Alpes, France',
    'Whistler, BC',
    'Niseko, Japan'
  ];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!inputValue.trim()) return;

    setIsLoading(true);
    setError(null);

    try {
      const response = await fetch('http://localhost:8000/pipeline', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          prompt: inputValue
        }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      
      // Extract the result string from the response
      setModalContent(data.result);
      setModalOpen(true);
    } catch (err) {
      console.error('Error making request:', err);
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setIsLoading(false);
    }
  };

  const handleSuggestionClick = (suggestion: string) => {
    setInputValue(suggestion);
  };

  return (
    <div className="app">
      <header className="header">
        <div className="logo">
          <Snowflake size={20} className="snowflake-icon" />
          <span className="app-name">GoSnow</span>
        </div>
      </header>

      <main className="main-content">
        <div className="central-container">
          <h1 className="welcome-title">Where do you wanna snowboard?</h1>
          
          <form onSubmit={handleSubmit} className="input-section">
            <div className="input-container">
              <input
                type="text"
                value={inputValue}
                onChange={(e) => setInputValue(e.target.value)}
                placeholder="Jay Peak, VT"
                className="search-input"
                disabled={isLoading}
              />
              <button 
                type="submit" 
                className={`submit-button ${isLoading ? 'loading' : ''}`}
                disabled={isLoading || !inputValue.trim()}
              >
                <ArrowUpRight size={16} />
              </button>
            </div>
            {error && <div className="error-message">{error}</div>}
          </form>

          <div className="suggestions">
            {suggestedQuestions.map((question, index) => (
              <button
                key={index}
                onClick={() => handleSuggestionClick(question)}
                className="suggestion-item"
              >
                <ArrowUpRight size={14} className="suggestion-arrow" />
                <span>{question}</span>
              </button>
            ))}
          </div>
        </div>
      </main>

      <Modal
        isOpen={modalOpen}
        onClose={() => setModalOpen(false)}
        content={modalContent}
        title="Snowboard Recommendation"
      />
    </div>
  );
}

export default App;