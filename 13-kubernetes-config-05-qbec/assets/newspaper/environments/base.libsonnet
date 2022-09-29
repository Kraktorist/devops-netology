
// this file has the baseline default parameters
{
  components: {
    postgres: {
      image: 'postgres:13-alpine',
      dbname: 'news',
      dbuser: 'postgres',
      port: 5432
    },
    backend: {
      image: 'kraktorist/news-backend:1.0',
      replicas: 1      
    },
    frontend: {
      image: 'kraktorist/news-frontend:1.4',
      replicas: 1      
    },
    pvc: {
      claimNameSuffix: 'static',
      storage: '100Mi'
    },
    ingress: {
      enable: false,
      externalEndpoint: false,
      hostname: 'newspaper',
    }
  },
}
