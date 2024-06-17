import React from "react";
import Section from "./Section";
import Heading from "./Heading";
import Arrow from '../assets/svg/Arrow'
import { benefits } from "../constants/index.Js";
import {GradientLight} from './design/Benefits';
import ClipPath from '../assets/svg/ClipPath'

const Benefits = () => {
  return (
    <Section id="features">
      <div className="container relative z-2">
        <Heading
          className="md:max-w-md lg:max-w-2xl"
          title="Chat Through your Soul, not just your phone with LenkSen"
        />
        <div className="flex flex-wrap gap-10 mb-10">
          {benefits.map((item) => (
            <div
              key={item.id}
              className=" block relative p-0.5 bg-no-repeat bg-[length:100%_100%] md:max-w-[24rem]"
              style={{
                backgroundImage: `url(${item.backgroundUrl})`,
              }}
            >
              <div className="relative z-2 flex flex-col min-h-[22rem] p-[2.4rem] pointer-events-none">
                <h5 className="h5 mb-5">{item.title}</h5>
                <p className="body-2 mb-6 text-n-3">{item.text}</p>
                <div className="flex items-center mt-auto">
                    <img src={item.iconUrl} width={48} height={48} alt={item.title} />
                    {/* <p className="ml-auto font-code text-xs- font-bold text-n-1 uppercase tracking-wider">Explore More</p> */}
                    {/* <Arrow/> */}
                </div>
              </div>
              {item.light && <GradientLight/>}
              <div className="absolute inset-0.5 bg-n-8" style={{ clipPath: "url(#benefits)" }}>
                <div className="asbolute inset-0 opacity-0 transition-opacity hover:opacity-30">
                    {item.imageUrl && (
                        <img src={item.imageUrl} width={380} height={362} alt={item.title} className="h-full w-full object-cover"/>
                    )}
                </div>
              </div>
              <ClipPath/>
            </div>
          ))}
        </div>
      </div>
    </Section>
  );
};
export default Benefits;
