import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  '0x937D117e3230072F095Cd10e43d2e33973c3426f'
);

export default instance;
