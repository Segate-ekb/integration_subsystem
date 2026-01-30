import { defineConfig } from 'vitepress'

export default defineConfig({
  // Site metadata
  title: '📦 Подсистема интеграции',
  description: 'Документация подсистемы интеграции для 1С:Предприятие',
  lang: 'ru-RU',
  
  // Build settings
  lastUpdated: true,
  cleanUrls: true,
  
  // Markdown settings
  markdown: {
    lineNumbers: true,
    theme: {
      light: 'github-light',
      dark: 'github-dark'
    }
  },
  
  // Theme configuration
  themeConfig: {
    // Logo and branding
    logo: '/images/logo.svg',
    siteTitle: 'Подсистема интеграции',
    
    // Navigation
    nav: [
      { text: 'Руководство', link: '/guide/' },
      { text: 'Концепции', link: '/concepts/' },
      { text: 'API', link: '/api/' },
      { text: 'Разработка', link: '/developer/' }
    ],
    
    // Sidebar configuration
    sidebar: {
      '/guide/': [
        {
          text: 'Начало работы',
          items: [
            { text: 'Введение', link: '/guide/' }
          ]
        },
        {
          text: 'Практические руководства',
          items: [
            { text: 'Создание потока данных', link: '/guide/create-flow' },
            { text: 'Настройка подписчиков', link: '/guide/configure-subscribers' }
          ]
        }
      ],
      '/concepts/': [
        {
          text: 'Основные концепции',
          items: [
            { text: 'Обзор архитектуры', link: '/concepts/' },
            { text: 'Потоки данных', link: '/concepts/data-flows' },
            { text: 'Подписчики', link: '/concepts/subscribers' },
            { text: 'Очереди сообщений', link: '/concepts/message-queues' },
            { text: 'Валидация', link: '/concepts/validation' },
            { text: 'Многопоточность', link: '/concepts/multithreading' },
            { text: 'Мониторинг и метрики', link: '/concepts/monitoring' }
          ]
        }
      ],
      '/api/': [
        {
          text: 'API Reference',
          items: [
            { text: 'Обзор', link: '/api/' }
          ]
        }
      ],
      '/developer/': [
        {
          text: 'Для разработчиков',
          items: [
            { text: 'Настройка окружения', link: '/developer/' }
          ]
        }
      ]
    },
    
    // Search
    search: {
      provider: 'local',
      options: {
        translations: {
          button: { buttonText: 'Поиск', buttonAriaLabel: 'Поиск' },
          modal: {
            noResultsText: 'Нет результатов',
            resetButtonTitle: 'Сбросить',
            footer: { selectText: 'выбрать', navigateText: 'навигация' }
          }
        }
      }
    },
    
    // Footer
    footer: {
      message: 'Документация подсистемы интеграции',
      copyright: `© ${new Date().getFullYear()} Подсистема интеграции`
    },
    
    // Social links
    socialLinks: [
      { icon: 'github', link: 'https://github.com/your-org/integration_subsystem' }
    ],
    
    // Last updated text
    lastUpdated: {
      text: 'Обновлено',
      formatOptions: { dateStyle: 'medium', timeStyle: 'short' }
    },
    
    // Outline
    outline: {
      level: [2, 3],
      label: 'На этой странице'
    },
    
    // Doc footer navigation
    docFooter: {
      prev: 'Предыдущая',
      next: 'Следующая'
    }
  }
})
