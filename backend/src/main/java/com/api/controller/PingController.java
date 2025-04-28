package com.api.controller;

import com.api.model.Item;
import com.api.repository.ItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class PingController {

    @Autowired
    private ItemRepository itemRepository;

    @GetMapping("/items")
    public List<Item> getAllItems() {
        return itemRepository.findAll();
    }

    @PostMapping("/items")
    public Item createItem(@RequestBody Item item) {
        return itemRepository.save(item);
    }

    @PutMapping("/items/{id}")
    public Item updateItem(@PathVariable Long id, @RequestBody Item itemDetails) {
        Item item = itemRepository.findById(id).orElseThrow(() -> new RuntimeException("Item not found"));
        item.setName(itemDetails.getName());
        return itemRepository.save(item);
    }

    @DeleteMapping("/items/{id}")
    public String deleteItem(@PathVariable Long id) {
        itemRepository.deleteById(id);
        return "Item deleted with ID: " + id;
    }
}