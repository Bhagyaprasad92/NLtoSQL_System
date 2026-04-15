package com.nl2sql.backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.nl2sql.backend.dto.Nl2SqlRequest;
import com.nl2sql.backend.dto.Nl2SqlResponse;
import com.nl2sql.backend.service.Nl2SqlService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/nl2sql")
@CrossOrigin(origins = "*")
public class Nl2SqlController {

    private final Nl2SqlService nl2SqlService;

    public Nl2SqlController(Nl2SqlService nl2SqlService) {
        this.nl2SqlService = nl2SqlService;
    }

    @PostMapping("/query")
    public ResponseEntity<Nl2SqlResponse> query(@Valid @RequestBody Nl2SqlRequest request) {
        Nl2SqlResponse response = nl2SqlService.processNaturalLanguageQuery(request.getQuery());
        return ResponseEntity.ok(response);
    }
}