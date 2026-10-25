USE MusicStoreSQL;

ALTER TABLE dbo.album WITH CHECK ADD CONSTRAINT FK_album_artist
    FOREIGN KEY (artist_id) REFERENCES dbo.artist (artist_id);
ALTER TABLE dbo.employee WITH CHECK ADD CONSTRAINT FK_employee_manager
    FOREIGN KEY (reports_to) REFERENCES dbo.employee (employee_id);
ALTER TABLE dbo.customer WITH CHECK ADD CONSTRAINT FK_customer_support_rep
    FOREIGN KEY (support_rep_id) REFERENCES dbo.employee (employee_id);
ALTER TABLE dbo.track WITH CHECK ADD CONSTRAINT FK_track_album
    FOREIGN KEY (album_id) REFERENCES dbo.album (album_id);
ALTER TABLE dbo.track WITH CHECK ADD CONSTRAINT FK_track_media_type
    FOREIGN KEY (media_type_id) REFERENCES dbo.media_type (media_type_id);
ALTER TABLE dbo.track WITH CHECK ADD CONSTRAINT FK_track_genre
    FOREIGN KEY (genre_id) REFERENCES dbo.genre (genre_id);
ALTER TABLE dbo.invoice WITH CHECK ADD CONSTRAINT FK_invoice_customer
    FOREIGN KEY (customer_id) REFERENCES dbo.customer (customer_id);
ALTER TABLE dbo.invoice_line WITH CHECK ADD CONSTRAINT FK_line_invoice
    FOREIGN KEY (invoice_id) REFERENCES dbo.invoice (invoice_id);
ALTER TABLE dbo.invoice_line WITH CHECK ADD CONSTRAINT FK_line_track
    FOREIGN KEY (track_id) REFERENCES dbo.track (track_id);
ALTER TABLE dbo.playlist_track WITH CHECK ADD CONSTRAINT FK_playlist_track_playlist
    FOREIGN KEY (playlist_id) REFERENCES dbo.playlist (playlist_id);
ALTER TABLE dbo.playlist_track WITH CHECK ADD CONSTRAINT FK_playlist_track_track
    FOREIGN KEY (track_id) REFERENCES dbo.track (track_id);

CREATE INDEX IX_album_artist ON dbo.album (artist_id);
CREATE INDEX IX_track_album ON dbo.track (album_id);
CREATE INDEX IX_track_genre ON dbo.track (genre_id);
CREATE INDEX IX_customer_support_rep ON dbo.customer (support_rep_id);
CREATE INDEX IX_invoice_customer ON dbo.invoice (customer_id);
CREATE INDEX IX_invoice_billing_country ON dbo.invoice (billing_country);
CREATE INDEX IX_invoice_line_invoice ON dbo.invoice_line (invoice_id);
CREATE INDEX IX_invoice_line_track ON dbo.invoice_line (track_id);
CREATE INDEX IX_playlist_track_track ON dbo.playlist_track (track_id);
