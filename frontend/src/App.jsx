import React, { useEffect, useState } from 'react';
import axios from 'axios';
import './App.css';

const App = () => {
  const [items, setItems] = useState([]);
  const [newItem, setNewItem] = useState('');

  const api = axios.create({
    baseURL: 'http://localhost:8080/api', // URL base de tu backend
  });

  // Obtener todos los ítems
  const fetchItems = async () => {
    try {
      const response = await api.get('/items');
      setItems(response.data);
    } catch (error) {
      console.error('Error fetching items:', error);
    }
  };

  // Crear un nuevo ítem
  const createItem = async () => {
    try {
      const response = await api.post('/items', { name: newItem });
      setItems([...items, response.data]);
      setNewItem('');
    } catch (error) {
      console.error('Error creating item:', error);
    }
  };

  // Actualizar un ítem
  const updateItem = async (id, newName) => {
    try {
      const response = await api.put(`/items/${id}`, { name: newName });
      setItems(items.map(item => (item.id === id ? response.data : item)));
    } catch (error) {
      console.error('Error updating item:', error);
    }
  };

  // Eliminar un ítem
  const deleteItem = async (id) => {
    try {
      await api.delete(`/items/${id}`);
      setItems(items.filter(item => item.id !== id));
    } catch (error) {
      console.error('Error deleting item:', error);
    }
  };

  useEffect(() => {
    fetchItems();
  }, []);

  return (
    <div>
      <h1>Item Manager</h1>
      <div>
        <input
          type="text"
          value={newItem}
          onChange={(e) => setNewItem(e.target.value)}
          placeholder="New item name"
        />
        <button onClick={createItem}>Add Item</button>
      </div>
      <ul>
        {items.map(item => (
          <li key={item.id}>
            <input
              type="text"
              value={item.name}
              onChange={(e) => updateItem(item.id, e.target.value)}
            />
            <button onClick={() => deleteItem(item.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default App;