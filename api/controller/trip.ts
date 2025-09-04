import express from 'express';
import { TripService } from '../service/trip.service';

export class TripController {
  static async getAll(req: express.Request, res: express.Response): Promise<void> {
    try {
      if (req.query.id) {
        const id = +req.query.id;
        const trips = await TripService.getById(id);
        res.json(trips);
      } else {
        const trips = await TripService.getAll();
        res.json(trips);
      }
    } catch (error) {
      console.error('Get trips error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getById(req: express.Request, res: express.Response): Promise<void> {
    try {
      const id = +req.params.id;
      const trips = await TripService.getById(id);
      res.json(trips);
    } catch (error) {
      console.error('Get trip by id error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async search(req: express.Request, res: express.Response): Promise<void> {
    try {
      const id = req.query.id as string;
      const name = req.query.name as string;
      const trips = await TripService.search(id, name);
      res.json(trips);
    } catch (error) {
      console.error('Search trips error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async create(req: express.Request, res: express.Response): Promise<void> {
    try {
      const trip = req.body;
      const result = await TripService.create(trip);
      res.status(201).json(result);
    } catch (error) {
      console.error('Create trip error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async update(req: express.Request, res: express.Response): Promise<void> {
    try {
      const id = +req.params.id;
      const trip = req.body;
      const result = await TripService.update(id, trip);
      if (result.affectedRows === 0) {
        res.status(404).json({ message: 'Trip not found' });
      } else {
        res.status(201).json(result);
      }
    } catch (error) {
      console.error('Update trip error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async delete(req: express.Request, res: express.Response): Promise<void> {
    try {
      const id = +req.params.id;
      const result = await TripService.delete(id);
      res.status(200).json(result);
    } catch (error) {
      console.error('Delete trip error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}
