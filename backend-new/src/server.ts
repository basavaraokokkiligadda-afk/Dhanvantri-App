import app from './app';
import { config } from './config/config';
import { connectDatabase } from './config/database';

/**
 * Start the server
 */
const startServer = async (): Promise<void> => {
  try {
    // Connect to database
    await connectDatabase();

    // Start Express server
    app.listen(config.port, () => {
      console.log('');
      console.log('╔═══════════════════════════════════════════════════╗');
      console.log('║   🏥  DHANVANTRI HEALTHCARE API SERVER          ║');
      console.log('╠═══════════════════════════════════════════════════╣');
      console.log(`║   Environment: ${config.env.padEnd(31)} ║`);
      console.log(`║   Port:        ${String(config.port).padEnd(31)} ║`);
      console.log(`║   API Version: ${config.apiVersion.padEnd(31)} ║`);
      console.log('╠═══════════════════════════════════════════════════╣');
      console.log(`║   🌐 Server:   http://localhost:${config.port.toString().padEnd(19)} ║`);
      console.log(`║   📊 Health:   http://localhost:${config.port}/health${''.padEnd(10)} ║`);
      console.log(`║   📚 API Docs: http://localhost:${config.port}/api/${config.apiVersion}${''.padEnd(6)} ║`);
      console.log('╚═══════════════════════════════════════════════════╝');
      console.log('');
      console.log('✨ Available Endpoints:');
      console.log(`   - POST   /api/${config.apiVersion}/auth/register`);
      console.log(`   - POST   /api/${config.apiVersion}/auth/login`);
      console.log(`   - GET    /api/${config.apiVersion}/doctors`);
      console.log(`   - POST   /api/${config.apiVersion}/appointments`);
      console.log(`   - POST   /api/${config.apiVersion}/payments/create`);
      console.log('');
    });

  } catch (error) {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
  }
};

// Handle unhandled promise rejections
process.on('unhandledRejection', (err: Error) => {
  console.error('❌ Unhandled Promise Rejection:', err);
  process.exit(1);
});

// Handle uncaught exceptions
process.on('uncaughtException', (err: Error) => {
  console.error('❌ Uncaught Exception:', err);
  process.exit(1);
});

// Start the server
startServer();
