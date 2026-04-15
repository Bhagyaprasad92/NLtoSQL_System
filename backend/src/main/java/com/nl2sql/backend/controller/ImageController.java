package com.nl2sql.backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.InputStream;
import java.net.URL;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class ImageController {
    @GetMapping("/image")
    public ResponseEntity<byte[]> getImage(@RequestParam String url) {
        try {
            URL imageUrl = new URL(url);
            InputStream in = imageUrl.openStream();
            byte[] imageBytes = in.readAllBytes();

            return ResponseEntity.ok()
                    .header("Content-Type", "image/jpeg")
                    .body(imageBytes);

        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
}
