import { createCampaign, advance, command } from '../../../packages/sim/src/travel.ts';

const world = createCampaign();
let timer;
function schedule() {
  clearInterval(timer);
  if (world.speed) timer = setInterval(() => {
    advance(world);
    postMessage(world);
    if (!world.speed) clearInterval(timer);
  }, 900 / world.speed);
}
self.onmessage = ({data}) => {
  if (data.type !== 'inspect') command(world, data);
  postMessage(world);
  schedule();
};
